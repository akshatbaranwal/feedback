class Data {
  final connection;

  Data(this.connection);

  dynamic student(String email) async {
    return await connection.query(
      '''
    select *
    from student
    where email = @email
    ''',
      substitutionValues: {
        'email': email,
      },
    );
  }

  dynamic faculty(String email) async {
    return await connection.query(
      '''
    select *
    from faculty
    where email = @email
    ''',
      substitutionValues: {
        'email': email,
      },
    );
  }

  dynamic adminStudent() async {
    return await connection.query('''
    select *
    from admin_student
    join student_admin using (id)
    ''');
  }

  dynamic adminFaculty() async {
    return await connection.query('''
    select *
    from admin_faculty
    join faculty_admin using (id)
    ''');
  }

  dynamic studentFacultyQuery(int id) async {
    return await connection.query(
      '''
    select fs.id, fs.subject, fs.body, fs.created_at, fs.modified_at, sf.reply, sf.created_at, sf.modified_at
    from faculty_student as fs
    join student_faculty as sf on sf.id = fs.id
    where fs.studentid = @id
    ''',
      substitutionValues: {
        'id': id,
      },
    );
  }

  dynamic studentFacultyFeedback(int sid, int fid) async {
    return await connection.query(
      '''
    select lecture, demo, slide, lab, syllabus, interaction, comment
    from faculty_rating
    where facultyid = @fid and studentid = @sid
    ''',
      substitutionValues: {
        'sid': sid,
        'fid': fid,
      },
    );
  }

  dynamic studentCourseFaculty(int id) async {
    return await connection.query(
      '''
    select f.email, f.name, c.coursename 
    from student as s 
    join branch_sem as bs on bs.branchid = s.branchid and bs.sem = (extract (month from now())::int / 6 + (extract (year from now())::int - s.year) * 2) 
    join branch_course using (branchsemid) 
    join course as c using (courseid) 
    join faculty as f using (courseid) 
    where s.studentid = @id
    ''',
      substitutionValues: {
        'id': id,
      },
    );
  }

  dynamic studentAdmin(int id) async {
    return await connection.query(
      '''
    select a.type, a.subject, a.body, a.created_at, a.modified_at, s.reply, s.created_at, s.modified_at
    from admin_student as a
    join student_admin as s using (id)
    where a.studentid = @id
    ''',
      substitutionValues: {
        'id': id,
      },
    );
  }

  dynamic facultyRating(int id) async {
    return await connection.query(
      '''
    select lecture, demo, slide, lab, syllabus, interaction
    from faculty_rating
    where facultyid = @id
    ''',
      substitutionValues: {
        'id': id,
      },
    );
  }

  dynamic facultyAdmin(int id) async {
    return await connection.query(
      '''
    select a.type, a.subject, a.body, a.created_at, a.modified_at, f.reply, f.created_at, f.modified_at
    from admin_faculty as a
    join faculty_admin as f using (id)
    where a.facultyid = @id
    ''',
      substitutionValues: {
        'id': id,
      },
    );
  }

  dynamic facultyCourse(String name) async {
    return await connection.query(
      '''
    select c.coursename
    from faculty as f
    join course as c using (courseid)
    where f.name = @name
    ''',
      substitutionValues: {
        'name': name,
      },
    );
  }

  dynamic checkStudent(String email) async {
    return await connection.query(
      '''
    select email from student
    where email = @email
    ''',
      substitutionValues: {
        'email': email,
      },
    );
  }

  dynamic checkFaculty(String email) async {
    return await connection.query(
      '''
    select email from faculty
    where email = @email
    ''',
      substitutionValues: {
        'email': email,
      },
    );
  }

  dynamic addStudent(
      String enroll, String email, String name, int branchid, int year) async {
    return await connection.query(
      '''
    insert into student (enroll, email, name, branchid, year)
    values (@enroll, @email, @name, @branchid, @year)
    ''',
      substitutionValues: {
        'enroll': enroll,
        'email': email,
        'name': name,
        'branchid': branchid,
        'year': year,
      },
    );
  }

  dynamic addFaculty(String email, String name, int courseid) async {
    return await connection.query(
      '''
    insert into faculty (email, name, courseid)
    values (@email, @name, @courseid)
    ''',
      substitutionValues: {
        'email': email,
        'name': name,
        'courseid': courseid,
      },
    );
  }

  dynamic addAdminStudent(
      int id, String type, String subject, String body) async {
    return await connection.query(
      '''
    insert into admin_student (studentid, type, subject, body)
    values (@id, @type, @subject, @body)
    ''',
      substitutionValues: {
        'id': id,
        'type': type,
        'subject': subject,
        'body': body,
      },
    );
  }

  dynamic addAdminFaculty(
      int id, String type, String subject, String body) async {
    return await connection.query(
      '''
    insert into admin_faculty (facultyid, type, subject, body)
    values (@id, @type, @subject, @body)
    ''',
      substitutionValues: {
        'id': id,
        'type': type,
        'subject': subject,
        'body': body,
      },
    );
  }

  dynamic addFacultyStudent(
      int sid, int fid, String subject, String body) async {
    return await connection.query(
      '''
    insert into faculty_student (studentid, facultyid, subject, body)
    values (@sid, @fid, @subject, @body)
    ''',
      substitutionValues: {
        'sid': sid,
        'fid': fid,
        'subject': subject,
        'body': body,
      },
    );
  }

  dynamic addStudentAdmin(int id, String reply) async {
    return await connection.query(
      '''
    insert into student_admin (id, reply)
    values (@id, @reply)
    ''',
      substitutionValues: {
        'id': id,
        'reply': reply,
      },
    );
  }

  dynamic addStudentFaculty(int id, String reply) async {
    return await connection.query(
      '''
    insert into student_faculty (id, reply)
    values (@id, @reply)
    ''',
      substitutionValues: {
        'id': id,
        'reply': reply,
      },
    );
  }

  dynamic addFacultyAdmin(int id, String reply) async {
    return await connection.query(
      '''
    insert into faculty_admin (id, reply)
    values (@id, @reply)
    ''',
      substitutionValues: {
        'id': id,
        'reply': reply,
      },
    );
  }

  // void main() async {
  //   await connection.open();
  //   var results = await studentCourseFaculty(1);
  //   print(results);
  //   await connection.close();
  // }
}
