import 'package:collection/collection.dart';

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
  final double lecture;
  final double demo;
  final double slide;
  final double lab;
  final double syllabus;
  final double interaction;

  FacultyRating({
    @required this.name,
    @required this.course,
    @required this.facultyid,
    @required this.lecture,
    @required this.demo,
    @required this.slide,
    @required this.lab,
    @required this.syllabus,
    @required this.interaction,
  });
}

class FacultyStudentList with ChangeNotifier {
  final connection;
  FacultyStudentList(this.connection);

  List<FacultyStudent> _items = [];
  List<FacultyRating> _ratings = [];

  List<FacultyStudent> get items {
    _items.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return [..._items];
  }

  List<FacultyRating> get ratings {
    return [..._ratings];
  }

  Future<void> fetch({
    @required User from,
    int id,
  }) async {
    if (id != null)
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
    where faculty_student.facultyid = @facultyid
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
    switch (from) {
      case User.student:
        try {
          var response = await connection.mappedResultsQuery(
            '''
    select faculty.name, faculty.facultyid, course.coursename, faculty_rating.*
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
          );
          if (response.isNotEmpty) {
            final List<FacultyRating> loadedData = [];
            response.forEach((val) {
              loadedData.add(FacultyRating(
                name: val['faculty']['name'],
                course: val['course']['coursename'],
                facultyid: val['faculty']['facultyid'],
                lecture: val['faculty_rating']['lecture'],
                demo: val['faculty_rating']['demo'],
                slide: val['faculty_rating']['slide'],
                lab: val['faculty_rating']['lab'],
                syllabus: val['faculty_rating']['syllabus'],
                interaction: val['faculty_rating']['interaction'],
              ));
            });
            _ratings = loadedData;
            notifyListeners();
          }
        } catch (error) {
          throw error;
        }
        break;

      case User.faculty:
        try {
          var response = await connection.mappedResultsQuery(
            '''
    select faculty.name, course.coursename, faculty_rating.*
    from faculty_rating
    join faculty using(facultyid)
    join course using(courseid)
    where faculty.facultyid = @facultyid
    ''',
            substitutionValues: {
              'facultyid': id,
            },
          );
          int len = response.length;
          if (len != 0) {
            var result = FacultyRating(
              name: '',
              course: '',
              facultyid: 0,
              lecture: 0,
              demo: 0,
              slide: 0,
              lab: 0,
              syllabus: 0,
              interaction: 0,
            );
            result = response.fold(
              result,
              (previousValue, element) => FacultyRating(
                name: element['faculty']['name'],
                course: element['course']['coursename'],
                facultyid: element['faculty_rating']['facultyid'],
                lecture: element['faculty_rating']['lecture'] / len +
                    previousValue.lecture,
                demo: element['faculty_rating']['demo'] / len +
                    previousValue.demo,
                slide: element['faculty_rating']['slide'] / len +
                    previousValue.slide,
                lab: element['faculty_rating']['lab'] / len + previousValue.lab,
                syllabus: element['faculty_rating']['syllabus'] / len +
                    previousValue.syllabus,
                interaction: element['faculty_rating']['interaction'] / len +
                    previousValue.interaction,
              ),
            );
            _ratings = [result];
            notifyListeners();
          }
        } catch (error) {
          throw error;
        }
        break;

      case User.admin:
        try {
          var response = await connection.mappedResultsQuery('''
    select faculty.name, course.coursename, faculty_rating.*
    from faculty_rating
    join faculty using(facultyid)
    join course using(courseid)
    ''');
          if (response.isNotEmpty) {
            var initialValue = FacultyRating(
              name: '',
              course: '',
              facultyid: 0,
              lecture: 0,
              demo: 0,
              slide: 0,
              lab: 0,
              syllabus: 0,
              interaction: 0,
            );
            int len;
            var result =
                groupBy(response, (obj) => obj['faculty_rating']['facultyid']);
            final List<FacultyRating> loadedData = [];
            result.forEach((key, value) {
              len = value.length;
              FacultyRating temp = value.fold(
                  initialValue,
                  (previousValue, element) => FacultyRating(
                        name: element['faculty']['name'],
                        course: element['course']['coursename'],
                        facultyid: element['faculty_rating']['facultyid'],
                        lecture: element['faculty_rating']['lecture'] / len +
                            previousValue.lecture,
                        demo: element['faculty_rating']['demo'] / len +
                            previousValue.demo,
                        slide: element['faculty_rating']['slide'] / len +
                            previousValue.slide,
                        lab: element['faculty_rating']['lab'] / len +
                            previousValue.lab,
                        syllabus: element['faculty_rating']['syllabus'] / len +
                            previousValue.syllabus,
                        interaction:
                            element['faculty_rating']['interaction'] / len +
                                previousValue.interaction,
                      ));
              loadedData.add(temp);
            });
            _ratings = loadedData;
            notifyListeners();
          }
        } catch (error) {
          throw error;
        }
        break;
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

  Future<void> updateRating({
    @required facultyid,
    @required studentid,
    @required lecture,
    @required demo,
    @required slide,
    @required lab,
    @required syllabus,
    @required interaction,
  }) async {
    try {
      final response = await connection.mappedResultsQuery(
        '''
      insert into faculty_rating
      values (@facultyid, @studentid, @lecture, @demo, @slide, @lab, @syllabus, @interaction)
      on conflict (facultyid, studentid) do UPDATE
      set facultyid = @facultyid, studentid = @studentid, lecture = @lecture, demo = @demo, slide = @slide, lab = @lab, syllabus = @syllabus, interaction = @interaction
      returning *
      ''',
        substitutionValues: {
          'studentid': studentid,
          'facultyid': facultyid,
          'lecture': lecture,
          'demo': demo,
          'slide': slide,
          'lab': lab,
          'syllabus': syllabus,
          'interaction': interaction,
        },
      );
      if (response.isNotEmpty) {
        var _prevRatingIndex =
            _ratings.indexWhere((element) => element.facultyid == facultyid);
        _ratings[_prevRatingIndex] = FacultyRating(
          name: _ratings[_prevRatingIndex].name,
          course: _ratings[_prevRatingIndex].course,
          facultyid: facultyid,
          lecture: lecture,
          demo: demo,
          slide: slide,
          lab: lab,
          syllabus: syllabus,
          interaction: interaction,
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
          id: response[0]['faculty_student']['id'],
          sem: response[0]['branch_sem']['sem'],
          course: response[0]['course']['coursename'],
          studentemail: response[0]['student']['email'],
          facultyemail: response[0]['faculty']['email'],
          studentname: response[0]['student']['name'],
          facultyname: response[0]['faculty']['name'],
          subject: response[0]['faculty_student']['subject'],
          body: response[0]['faculty_student']['body'],
          createdAt: response[0]['faculty_student']['created_at'],
          modifiedAt: response[0]['faculty_student']['modified_at'],
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
