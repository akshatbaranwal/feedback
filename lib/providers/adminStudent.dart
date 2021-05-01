import '../import.dart';

class AdminStudent {
  final int id;
  final int sem;
  final String studentname;
  final String studentemail;
  final String branch;
  final String type;
  final String subject;
  final String body;
  final DateTime createdAt;
  final DateTime modifiedAt;
  final String reply;
  final DateTime replyCreatedAt;
  final DateTime replyModifiedAt;

  AdminStudent({
    @required this.id,
    @required this.sem,
    @required this.studentname,
    @required this.studentemail,
    @required this.branch,
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

class AdminStudentList with ChangeNotifier {
  final connection;
  AdminStudentList(this.connection);

  List<AdminStudent> _items = [];

  List<AdminStudent> get items {
    _items.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return [..._items];
  }

  Future<void> fetch({studentid}) async {
    if (connection.isClosed) await connection.open();
    try {
      final response = studentid == null
          ? await connection.mappedResultsQuery('''
    select *
    from admin_student
    left join student_admin using (id)
    join student using (studentid)
    join branch_sem on branch_sem.branchid = student.branchid and branch_sem.sem = (extract (month from now())::int / 6 + (extract (year from now())::int - student.year) * 2) 
    join branch on branch.branchid = branch_sem.branchid
    ''')
          : await connection.mappedResultsQuery(
              '''
    select *
    from admin_student
    left join student_admin using (id)
    join student using (studentid)
    join branch_sem on branch_sem.branchid = student.branchid and branch_sem.sem = (extract (month from now())::int / 6 + (extract (year from now())::int - student.year) * 2) 
    join branch on branch.branchid = branch_sem.branchid
    where student.studentid = @studentid
    ''',
              substitutionValues: {
                'studentid': studentid,
              },
            );
      final List<AdminStudent> loadedData = [];
      if (response.isNotEmpty) {
        response.forEach((val) {
          loadedData.add(AdminStudent(
            id: val['admin_student']['id'],
            studentname: val['student']['name'],
            studentemail: val['student']['email'],
            sem: val['branch_sem']['sem'],
            branch: val['branch']['branchname'],
            type: val['admin_student']['type'],
            subject: val['admin_student']['subject'],
            body: val['admin_student']['body'],
            createdAt: val['admin_student']['created_at']?.toLocal(),
            modifiedAt: val['admin_student']['modified_at']?.toLocal(),
            reply: val['student_admin']['reply'],
            replyCreatedAt: val['student_admin']['created_at']?.toLocal(),
            replyModifiedAt: val['student_admin']['modified_at']?.toLocal(),
          ));
        });
      }
      _items = loadedData;
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Future<void> reply({
    @required reply,
    @required id,
  }) async {
    if (connection.isClosed) await connection.open();
    final index = _items.indexWhere((element) => element.id == id);
    try {
      final response = await connection.mappedResultsQuery(
        '''
    insert into student_admin (id, reply)
    values (@id, @reply)
    returning *
    ''',
        substitutionValues: {
          'id': id,
          'reply': reply,
        },
      );
      if (response.isNotEmpty) {
        _items[index] = AdminStudent(
          id: _items[index].id,
          studentname: _items[index].studentname,
          studentemail: _items[index].studentemail,
          branch: _items[index].branch,
          sem: _items[index].sem,
          type: _items[index].type,
          subject: _items[index].subject,
          body: _items[index].body,
          createdAt: _items[index].createdAt,
          modifiedAt: _items[index].modifiedAt,
          reply: response[0]['student_admin']['reply'],
          replyCreatedAt: response[0]['student_admin']['created_at']?.toLocal(),
          replyModifiedAt:
              response[0]['student_admin']['modified_at']?.toLocal(),
        );
        notifyListeners();
      }
    } catch (error) {
      throw (error);
    }
  }

  Future<void> add({
    @required studentid,
    @required type,
    @required subject,
    @required body,
  }) async {
    if (connection.isClosed) await connection.open();
    try {
      final response = await connection.mappedResultsQuery(
        '''
    with inserted as (
      insert into admin_student (studentid, type, subject, body)
      values (@studentid, @type, @subject, @body)
      returning *
    ) select *
    from inserted
    join student using (studentid)
    join branch_sem on branch_sem.branchid = student.branchid and branch_sem.sem = (extract (month from now())::int / 6 + (extract (year from now())::int - student.year) * 2) 
    join branch on branch.branchid = branch_sem.branchid
    ''',
        substitutionValues: {
          'studentid': studentid,
          'type': type,
          'subject': subject,
          'body': body,
        },
      );
      if (response.isNotEmpty) {
        _items.add(AdminStudent(
          id: response[0]['admin_student']['id'],
          studentname: response[0]['student']['name'],
          studentemail: response[0]['student']['email'],
          sem: response[0]['branch_sem']['sem'],
          branch: response[0]['branch']['branchname'],
          type: response[0]['admin_student']['type'],
          subject: response[0]['admin_student']['subject'],
          body: response[0]['admin_student']['body'],
          createdAt: response[0]['admin_student']['created_at']?.toLocal(),
          modifiedAt: response[0]['admin_student']['modified_at']?.toLocal(),
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

  void logout() {
    _items = [];
  }
}
