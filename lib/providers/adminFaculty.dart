import '../import.dart';

class AdminFaculty {
  final int id;
  final String name;
  final String email;
  final String course;
  final String type;
  final String subject;
  final String body;
  final DateTime createdAt;
  final DateTime modifiedAt;
  final String reply;
  final DateTime replyCreatedAt;
  final DateTime replyModifiedAt;

  AdminFaculty({
    @required this.id,
    @required this.name,
    @required this.email,
    @required this.course,
    @required this.type,
    @required this.subject,
    @required this.body,
    @required this.createdAt,
    @required this.modifiedAt,
    @required this.reply,
    @required this.replyCreatedAt,
    @required this.replyModifiedAt,
  });
}

class AdminFacultyList with ChangeNotifier {
  final connection;
  AdminFacultyList(this.connection);

  List<AdminFaculty> _items = [];

  List<AdminFaculty> get items {
    return [..._items].reversed.toList();
  }

  Future<void> fetch({facultyid}) async {
    try {
      final response = facultyid == null
          ? await connection.mappedResultsQuery('''
    select *
    from admin_faculty
    left join faculty_admin using (id)
    join faculty using (facultyid)
    join course using (courseid)
    ''')
          : await connection.mappedResultsQuery(
              '''
    select *
    from admin_faculty
    left join faculty_admin using (id)
    join faculty using (facultyid)
    join course using (courseid)
    where facultyid = @facultyid
    ''',
              substitutionValues: {
                'facultyid': facultyid,
              },
            );
      if (response.isNotEmpty) {
        final List<AdminFaculty> loadedData = [];
        response.forEach((val) {
          loadedData.add(AdminFaculty(
            id: val['admin_faculty']['id'],
            name: val['faculty']['name'],
            email: val['faculty']['email'],
            course: val['course']['coursename'],
            type: val['admin_faculty']['type'],
            subject: val['admin_faculty']['subject'],
            body: val['admin_faculty']['body'],
            createdAt: val['admin_faculty']['created_at'],
            modifiedAt: val['admin_faculty']['modified_at'],
            reply: val['faculty_admin']['reply'],
            replyCreatedAt: val['faculty_admin']['created_at'],
            replyModifiedAt: val['faculty_admin']['modified_at'],
          ));
        });
        _items = loadedData;
        notifyListeners();
      }
    } catch (error) {
      throw (error);
    }
  }

  Future<void> reply({
    @required reply,
    @required id,
  }) async {
    final index = _items.indexWhere((element) => element.id == id);
    try {
      final response = await connection.mappedResultsQuery(
        '''
    insert into faculty_admin (id, reply)
    values (@id, @reply)
    returning *
    ''',
        substitutionValues: {
          'id': id,
          'reply': reply,
        },
      );
      if (response.isNotEmpty) {
        _items[index] = AdminFaculty(
          id: _items[index].id,
          name: _items[index].name,
          email: _items[index].email,
          course: _items[index].course,
          type: _items[index].type,
          subject: _items[index].subject,
          body: _items[index].body,
          createdAt: _items[index].createdAt,
          modifiedAt: _items[index].modifiedAt,
          reply: response[0]['faculty_admin']['reply'],
          replyCreatedAt: response[0]['faculty_admin']['created_at'],
          replyModifiedAt: response[0]['faculty_admin']['modified_at'],
        );
        notifyListeners();
      }
    } catch (error) {
      throw (error);
    }
  }

  Future<void> add({
    @required facultyid,
    @required type,
    @required subject,
    @required body,
  }) async {
    try {
      final response = await connection.mappedResultsQuery(
        '''
    with inserted as (
      insert into admin_faculty (facultyid, type, subject, body)
      values (@facultyid, @type, @subject, @body)
      returning *
    ) select *
    from inserted
    join faculty using (facultyid)
    join course using (courseid)
    ''',
        substitutionValues: {
          'facultyid': facultyid,
          'type': type,
          'subject': subject,
          'body': body,
        },
      );
      if (response.isNotEmpty) {
        _items.add(AdminFaculty(
          id: response[0]['inserted']['id'],
          name: response[0]['faculty']['name'],
          email: response[0]['faculty']['email'],
          course: response[0]['course']['coursename'],
          type: response[0]['inserted']['type'],
          subject: response[0]['inserted']['subject'],
          body: response[0]['inserted']['body'],
          createdAt: response[0]['inserted']['created_at'],
          modifiedAt: response[0]['inserted']['modified_at'],
          reply: null,
          replyCreatedAt: null,
          replyModifiedAt: null,
        ));
        notifyListeners();
      }
    } catch (error) {
      throw (error);
    }
  }
}
