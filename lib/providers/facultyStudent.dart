import '../import.dart';

class FacultyStudent {
  final int id;
  final int sem;
  final String course;
  final String studentemail;
  final String facultyemail;
  final String studentname;
  final String facultyname;
  final String subject;
  final String body;
  final DateTime createdAt;
  final DateTime modifiedAt;
  final String reply;
  final DateTime replyCreatedAt;
  final DateTime replyModifiedAt;

  FacultyStudent({
    @required this.id,
    @required this.sem,
    @required this.course,
    @required this.studentemail,
    @required this.facultyemail,
    @required this.studentname,
    @required this.facultyname,
    @required this.subject,
    @required this.body,
    @required this.createdAt,
    @required this.modifiedAt,
    @required this.reply,
    @required this.replyCreatedAt,
    @required this.replyModifiedAt,
  });
}

class FacultyRating {
  final String name;
  final String course;
  final int facultyid;
  final int studentid;
  final int lecture;
  final int demo;
  final int slide;
  final int lab;
  final int syllabus;
  final int interaction;
  final String comment;

  FacultyRating({
    @required this.name,
    @required this.course,
    @required this.facultyid,
    @required this.studentid,
    @required this.lecture,
    @required this.demo,
    @required this.slide,
    @required this.lab,
    @required this.syllabus,
    @required this.interaction,
    @required this.comment,
  });
}

class FacultyStudentList with ChangeNotifier {
  final connection;
  FacultyStudentList(this.connection);

  List<FacultyStudent> _items = [];
  List<FacultyRating> _ratings = [];

  List<FacultyStudent> get items {
    return [..._items].reversed.toList();
  }

  List<FacultyRating> get ratings {
    return [..._ratings].reversed.toList();
  }

  Future<void> fetch({
    @required User from,
    @required int id,
  }) async {
    try {
      final response = from == User.student
          ? await connection.mappedResultsQuery('''
    select *
    from faculty_student
    left join student_faculty using (id)
    join student using (studentid)
    join faculty using (facultyid)
    join course using (courseid)
    join branch_sem on branch_sem.branchid = student.branchid and branch_sem.sem = (extract (month from now())::int / 6 + (extract (year from now())::int - student.year) * 2)
    where faculty_student.studentid = @studentid
    ''', substitutionValues: {
              'studentid': id,
            })
          : await connection.mappedResultsQuery('''
    select *
    from faculty_student
    left join student_faculty using (id)
    join student using (studentid)
    join faculty using (facultyid)
    join course using (courseid)
    join branch_sem on branch_sem.branchid = student.branchid and branch_sem.sem = (extract (month from now())::int / 6 + (extract (year from now())::int - student.year) * 2)
    where faculty_student.facultyid == @facultyid
    ''', substitutionValues: {
              'facultyid': id,
            });
      if (response.isNotEmpty) {
        final List<FacultyStudent> loadedData = [];
        response.forEach((val) {
          loadedData.add(FacultyStudent(
            id: val['faculty_student']['id'],
            sem: val['branch_sem']['sem'],
            studentemail: val['student']['email'],
            course: val['course']['coursename'],
            facultyemail: val['faculty']['email'],
            studentname: val['student']['name'],
            facultyname: val['faculty']['name'],
            subject: val['faculty_student']['subject'],
            body: val['faculty_student']['body'],
            createdAt: val['faculty_student']['created_at'],
            modifiedAt: val['faculty_student']['modified_at'],
            reply: val['student_faculty']['reply'],
            replyCreatedAt: val['student_faculty']['created_at'],
            replyModifiedAt: val['student_faculty']['modified_at'],
          ));
        });
        _items = loadedData;
        notifyListeners();
      }
    } catch (error) {
      throw (error);
    }

    try {
      final response = from == User.student
          ? await connection.mappedResultsQuery(
              '''
    select faculty.name, course.coursename, faculty_rating.*
    from student
    join branch_sem on branch_sem.branchid = student.branchid and branch_sem.sem = (extract (month from now())::int / 6 + (extract (year from now())::int - student.year) * 2)
    join branch_course using (branchsemid)
    join course using (courseid)
    join faculty using (courseid)
    left join faculty_rating on faculty_rating.studentid = student.studentid and faculty_rating.facultyid = faculty.facultyid
    where student.studentid = @studentid
    ''',
              substitutionValues: {
                'studentid': id,
              },
            )
          : await connection.mappedResultsQuery(
              '''
    select faculty.name, course.coursename, faculty_rating.*
    from faculty
    join course using (courseid)
    join faculty_rating using (facultyid)
    where facultyid = @facultyid
    ''',
              substitutionValues: {
                'facultyid': id,
              },
            );
      if (response.isNotEmpty) {
        final List<FacultyRating> loadedData = [];
        response.forEach((val) {
          loadedData.add(FacultyRating(
            name: val['faculty']['name'],
            course: val['course']['coursename'],
            facultyid: val['faculty_rating']['facultyid'],
            studentid: val['faculty_rating']['studentid'],
            lecture: val['faculty_rating']['lecture'],
            demo: val['faculty_rating']['demo'],
            slide: val['faculty_rating']['slide'],
            lab: val['faculty_rating']['lab'],
            syllabus: val['faculty_rating']['syllabus'],
            interaction: val['faculty_rating']['interaction'],
            comment: val['faculty_rating']['comment'],
          ));
        });
        _ratings = loadedData;
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
    insert into student_faculty (id, reply)
    values (@id, @reply)
    returning *
    ''',
        substitutionValues: {
          'id': id,
          'reply': reply,
        },
      );
      if (response.isNotEmpty) {
        _items[index] = FacultyStudent(
          id: _items[index].id,
          sem: _items[index].sem,
          studentname: _items[index].studentname,
          facultyname: _items[index].facultyname,
          course: _items[index].course,
          studentemail: _items[index].studentemail,
          facultyemail: _items[index].facultyemail,
          subject: _items[index].subject,
          body: _items[index].body,
          createdAt: _items[index].createdAt,
          modifiedAt: _items[index].modifiedAt,
          reply: response[0]['student_faculty']['reply'],
          replyCreatedAt: response[0]['student_faculty']['created_at'],
          replyModifiedAt: response[0]['student_faculty']['modified_at'],
        );
        notifyListeners();
      }
    } catch (error) {
      throw (error);
    }
  }

  Future<void> add({
    @required facultyid,
    @required studentid,
    @required subject,
    @required body,
  }) async {
    try {
      final response = await connection.mappedResultsQuery(
        '''
    with inserted as (
      insert into faculty_student (studentid, facultyid, subject, body)
      values (@studentid, @facultyid, @subject, @body)
      returning *
    ) select *
    from inserted
    join student using (studentid)
    join faculty using (facultyid)
    join course using (courseid)
    join branch_sem on branch_sem.branchid = student.branchid and branch_sem.sem = (extract (month from now())::int / 6 + (extract (year from now())::int - student.year) * 2)
    ''',
        substitutionValues: {
          'studentid': studentid,
          'facultyid': facultyid,
          'subject': subject,
          'body': body,
        },
      );
      if (response.isNotEmpty) {
        _items.add(FacultyStudent(
          id: response[0]['inserted']['id'],
          sem: response[0]['branch_sem']['sem'],
          course: response[0]['course']['coursename'],
          studentemail: response[0]['student']['email'],
          facultyemail: response[0]['faculty']['email'],
          studentname: response[0]['student']['name'],
          facultyname: response[0]['faculty']['name'],
          subject: response['inserted']['subject'],
          body: response['inserted']['body'],
          createdAt: response['inserted']['created_at'],
          modifiedAt: response['inserted']['modified_at'],
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
