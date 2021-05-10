import '../import.dart';

class FacultyStudent {
  final int id;
  final int sem;
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
  final int facultyid;
  final String facultyname;
  final int courseid;
  final String coursename;
  final double lecture;
  final double demo;
  final double slide;
  final double lab;
  final double syllabus;
  final double interaction;

  FacultyRating({
    @required this.facultyid,
    @required this.facultyname,
    @required this.courseid,
    @required this.coursename,
    @required this.lecture,
    @required this.demo,
    @required this.slide,
    @required this.lab,
    @required this.syllabus,
    @required this.interaction,
  });
}

class FacultyStudentList with ChangeNotifier {
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
    if (connection.isClosed) await initConnection();
    if (id != null)
      try {
        final response = from == User.student
            ? await connection.mappedResultsQuery('''
    select
      faculty_student.id,
      branch_sem.sem,
      student.email,
      faculty.email,
      student.name,
      faculty.name,
      faculty_student.subject,
      faculty_student.body,
      faculty_student.created_at,
      faculty_student.modified_at,
      student_faculty.reply,
      student_faculty.created_at,
      student_faculty.modified_at
    from faculty_student
    left join student_faculty using (id)
    join student using (studentid)
    join faculty using (facultyid)
    join branch_sem on branch_sem.branchid = student.branchid and branch_sem.sem = (extract (month from now())::int / 6 + (extract (year from now())::int - student.year) * 2)
    where faculty_student.studentid = @studentid
    ''', substitutionValues: {
                'studentid': id,
              })
            : await connection.mappedResultsQuery('''
    select
      faculty_student.id,
      branch_sem.sem,
      student.email,
      faculty.email,
      student.name,
      faculty.name,
      faculty_student.subject,
      faculty_student.body,
      faculty_student.created_at,
      faculty_student.modified_at,
      student_faculty.reply,
      student_faculty.created_at,
      student_faculty.modified_at
    from faculty_student
    left join student_faculty using (id)
    join student using (studentid)
    join faculty using (facultyid)
    join branch_sem on branch_sem.branchid = student.branchid and branch_sem.sem = (extract (month from now())::int / 6 + (extract (year from now())::int - student.year) * 2)
    where faculty_student.facultyid = @facultyid
    ''', substitutionValues: {
                'facultyid': id,
              });
        final List<FacultyStudent> loadedData = [];
        if (response.isNotEmpty) {
          response.forEach((val) {
            loadedData.add(FacultyStudent(
              id: val['faculty_student']['id'],
              sem: val['branch_sem']['sem'],
              studentemail: val['student']['email'],
              facultyemail: val['faculty']['email'],
              studentname: val['student']['name'],
              facultyname: val['faculty']['name'],
              subject: val['faculty_student']['subject'],
              body: val['faculty_student']['body'],
              createdAt: val['faculty_student']['created_at']?.toLocal(),
              modifiedAt: val['faculty_student']['modified_at']?.toLocal(),
              reply: val['student_faculty']['reply'],
              replyCreatedAt: val['student_faculty']['created_at']?.toLocal(),
              replyModifiedAt: val['student_faculty']['modified_at']?.toLocal(),
            ));
          });
        }
        _items = loadedData;
        notifyListeners();
      } catch (error) {
        throw (error);
      }
    switch (from) {
      case User.student:
        try {
          var response = await connection.mappedResultsQuery(
            '''
    select faculty.name, faculty.facultyid, course.courseid, course.coursename, faculty_rating.lecture, faculty_rating.demo, faculty_rating.slide, faculty_rating.lab, faculty_rating.syllabus, faculty_rating.interaction
    from student
    join branch_sem on branch_sem.branchid = student.branchid and branch_sem.sem = (extract (month from now())::int / 6 + (extract (year from now())::int - student.year) * 2)
    join branch_course using (branchsemid)
    join course using (courseid)
    join faculty_course using (courseid)
    join faculty using (facultyid)
    left join faculty_rating on faculty_rating.studentid = student.studentid and faculty_rating.facultyid = faculty.facultyid and faculty_rating.courseid = course.courseid
    where student.studentid = @studentid
    ''',
            substitutionValues: {
              'studentid': id,
            },
          );
          final List<FacultyRating> loadedData = [];
          if (response.isNotEmpty) {
            response.forEach((val) {
              loadedData.add(FacultyRating(
                facultyid: val['faculty']['facultyid'],
                facultyname: val['faculty']['name'],
                courseid: val['course']['courseid'],
                coursename: val['course']['coursename'],
                lecture: val['faculty_rating']['lecture'],
                demo: val['faculty_rating']['demo'],
                slide: val['faculty_rating']['slide'],
                lab: val['faculty_rating']['lab'],
                syllabus: val['faculty_rating']['syllabus'],
                interaction: val['faculty_rating']['interaction'],
              ));
            });
          }
          _ratings = loadedData;
          notifyListeners();
        } catch (error) {
          throw error;
        }
        break;

      case User.faculty:
        try {
          var response = await connection.mappedResultsQuery(
            '''
    select faculty.name, course.courseid, course.coursename, faculty_rating.lecture, faculty_rating.demo, faculty_rating.slide, faculty_rating.lab, faculty_rating.syllabus, faculty_rating.interaction
    from faculty_rating
    join faculty using (facultyid)
    join course using (courseid)
    where faculty_rating.facultyid = @facultyid
    ''',
            substitutionValues: {
              'facultyid': id,
            },
          );
          final List<FacultyRating> loadedData = [];
          if (response.isNotEmpty) {
            var initialValue = FacultyRating(
              facultyid: 0,
              facultyname: '',
              courseid: 0,
              coursename: '',
              lecture: 0,
              demo: 0,
              slide: 0,
              lab: 0,
              syllabus: 0,
              interaction: 0,
            );
            int len;
            var result = groupBy(response, (obj) => obj['course']['courseid']);
            result.forEach((key, value) {
              len = value.length;
              FacultyRating temp = value.fold(
                  initialValue,
                  (previousValue, element) => FacultyRating(
                        facultyid: id,
                        facultyname: element['faculty']['name'],
                        courseid: element['course']['courseid'],
                        coursename: element['course']['coursename'],
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
          }
          _ratings = loadedData;
          notifyListeners();
        } catch (error) {
          throw error;
        }
        break;

      case User.admin:
        try {
          var response = await connection.mappedResultsQuery('''
    select faculty.facultyid, faculty.name, course.courseid, course.coursename, faculty_rating.lecture, faculty_rating.demo, faculty_rating.slide, faculty_rating.lab, faculty_rating.syllabus, faculty_rating.interaction
    from faculty_rating
    join faculty using (facultyid)
    join course using (courseid)
    ''');
          final List<FacultyRating> loadedData = [];
          if (response.isNotEmpty) {
            int len;
            var result = groupBy(
                response,
                (obj) =>
                    "${obj['faculty']['facultyid']}:${obj['course']['courseid']}");
            result.forEach((key, value) {
              var initialValue = FacultyRating(
                facultyid: 0,
                facultyname: '',
                courseid: 0,
                coursename: '',
                lecture: 0,
                demo: 0,
                slide: 0,
                lab: 0,
                syllabus: 0,
                interaction: 0,
              );
              len = value.length;
              FacultyRating temp = value.fold(
                  initialValue,
                  (previousValue, element) => FacultyRating(
                        facultyid: element['faculty']['facultyid'],
                        facultyname: element['faculty']['name'],
                        courseid: element['course']['courseid'],
                        coursename: element['course']['coursename'],
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
          }
          _ratings = loadedData;
          notifyListeners();
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
    if (connection.isClosed) await initConnection();
    final index = _items.indexWhere((element) => element.id == id);
    try {
      final response = await connection.mappedResultsQuery(
        '''
    insert into student_faculty (id, reply)
    values (@id, @reply)
    returning student_faculty.created_at, student_faculty.modified_at
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
          studentemail: _items[index].studentemail,
          facultyemail: _items[index].facultyemail,
          subject: _items[index].subject,
          body: _items[index].body,
          createdAt: _items[index].createdAt,
          modifiedAt: _items[index].modifiedAt,
          reply: reply,
          replyCreatedAt:
              response[0]['student_faculty']['created_at']?.toLocal(),
          replyModifiedAt:
              response[0]['student_faculty']['modified_at']?.toLocal(),
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
    @required courseid,
  }) async {
    if (connection.isClosed) await initConnection();
    try {
      final response = await connection.mappedResultsQuery(
        '''
      insert into faculty_rating
      values (@facultyid, @studentid, @lecture, @demo, @slide, @lab, @syllabus, @interaction, @courseid)
      on conflict (facultyid, studentid, courseid) do UPDATE
      set facultyid = @facultyid, studentid = @studentid, lecture = @lecture, demo = @demo, slide = @slide, lab = @lab, syllabus = @syllabus, interaction = @interaction, courseid = @courseid
      returning studentid
      ''',
        substitutionValues: {
          'facultyid': facultyid,
          'studentid': studentid,
          'lecture': lecture,
          'demo': demo,
          'slide': slide,
          'lab': lab,
          'syllabus': syllabus,
          'interaction': interaction,
          'courseid': courseid,
        },
      );
      if (response.isNotEmpty) {
        var _prevRatingIndex = _ratings.indexWhere((element) =>
            element.facultyid == facultyid && element.courseid == courseid);
        var temp = FacultyRating(
          facultyid: facultyid,
          facultyname: _ratings[_prevRatingIndex].facultyname,
          courseid: courseid,
          coursename: _ratings[_prevRatingIndex].coursename,
          lecture: lecture,
          demo: demo,
          slide: slide,
          lab: lab,
          syllabus: syllabus,
          interaction: interaction,
        );
        if (_prevRatingIndex == -1)
          _ratings.add(temp);
        else
          _ratings[_prevRatingIndex] = temp;
        notifyListeners();
      }
    } catch (error) {
      throw (error);
    }
  }

  Future<void> add({
    @required sem,
    @required studentemail,
    @required studentname,
    @required facultyid,
    @required studentid,
    @required subject,
    @required body,
  }) async {
    if (connection.isClosed) await initConnection();
    try {
      final response = await connection.mappedResultsQuery(
        '''
    with inserted as (
      insert into faculty_student (studentid, facultyid, subject, body)
      values (@studentid, @facultyid, @subject, @body)
      returning *
    ) select inserted.id, inserted.created_at, inserted.modified_at, faculty.name, faculty.email
    from inserted
    join faculty using (facultyid)
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
          sem: sem,
          studentemail: studentemail,
          facultyemail: response[0]['faculty']['email'],
          studentname: studentname,
          facultyname: response[0]['faculty']['name'],
          subject: subject,
          body: body,
          createdAt: response[0]['faculty_student']['created_at']?.toLocal(),
          modifiedAt: response[0]['faculty_student']['modified_at']?.toLocal(),
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
    _ratings = [];
  }
}
