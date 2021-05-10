import '../import.dart';

class Faculty {
  final int facultyid;
  final String email;
  final String name;
  final List<int> courseid;

  Faculty({
    @required this.facultyid,
    @required this.email,
    @required this.name,
    @required this.courseid,
  });
}

class FacultyData with ChangeNotifier {
  var _emailList = [];
  var _courseList = [];
  Faculty _data;

  List<String> get emailList {
    return [..._emailList];
  }

  List<dynamic> get courseList {
    return [..._courseList];
  }

  Faculty get data {
    return _data == null
        ? null
        : Faculty(
            courseid: _data.courseid,
            email: _data.email,
            facultyid: _data.facultyid,
            name: _data.name,
          );
  }

  Future<void> fetchCourses() async {
    if (connection.isClosed) await initConnection();
    try {
      final response = await connection.query('''
      select *
      from course
      ''');
      final loadedCourses = [];
      if (response.isNotEmpty) {
        response.forEach((val) {
          loadedCourses.add([val[0], val[1]]);
        });
      }
      _courseList = loadedCourses;
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Future<void> fetchEmails() async {
    if (connection.isClosed) await initConnection();
    try {
      final response = await connection.query('''
      select email 
      from faculty
      ''');
      final loadedEmails = [];
      if (response.isNotEmpty) {
        response.forEach((element) {
          loadedEmails.add(element[0]);
        });
      }
      _emailList = loadedEmails;
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Future<void> login({
    @required email,
    @required password,
  }) async {
    if (connection.isClosed) await initConnection();
    try {
      final response = await connection.query(
        '''
    select facultyid, email, name, courseid
    from faculty
    join faculty_course using (facultyid)
    where email = @email
    and password = crypt(@password, password)
    ''',
        substitutionValues: {
          'email': email,
          'password': password,
        },
      );
      Faculty temp;
      if (response.isNotEmpty) {
        List<int> courseid = [];
        response.forEach((val) {
          courseid.add(val[3]);
        });
        temp = Faculty(
          facultyid: response[0][0],
          email: response[0][1],
          name: response[0][2],
          courseid: courseid,
        );
      }
      _data = temp;
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Future<void> register({
    @required email,
    @required password,
    @required name,
    @required courseid,
  }) async {
    if (connection.isClosed) await initConnection();
    try {
      final response = await connection.query(
        '''
    insert into faculty (email, password, name)
    values (@email, crypt(@password, gen_salt('bf')), @name)
    returning *
    ''',
        substitutionValues: {
          'email': email,
          'password': password,
          'name': name,
        },
      );
      Faculty temp;
      if (response.isNotEmpty) {
        await courseid.forEach((val) {
          connection.query(
            '''
      insert into faculty_course
      values (@facultyid, @courseid)
      ''',
            substitutionValues: {
              'facultyid': response[0][0],
              'courseid': val,
            },
          );
        });
        temp = Faculty(
          facultyid: response[0][0],
          email: email,
          name: name,
          courseid: courseid,
        );
        _emailList.add(temp.email);
      }
      _data = temp;
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Future<void> updateDetails({
    @required name,
    @required List<int> courseid,
  }) async {
    if (connection.isClosed) await initConnection();
    try {
      final response = await connection.query(
        '''
    update faculty
    set name = @name
    where facultyid = @facultyid
    returning *
    ''',
        substitutionValues: {
          'name': name,
          'facultyid': _data.facultyid,
        },
      );
      if (response.isNotEmpty) {
        List<List<Object>> response2 = await connection.query(
          '''
        select courseid
        from faculty_course
        where facultyid = @facultyid
        ''',
          substitutionValues: {
            'facultyid': _data.facultyid,
          },
        );

        List<int> toDelete = [];
        response2.forEach((element) {
          if (!courseid.contains(element[0])) toDelete.add(element[0] as int);
        });

        if (connection.isClosed) await initConnection();
        toDelete.forEach((val) async {
          await connection.query(
            '''
          delete from faculty_course
          where facultyid = @facultyid and courseid = @courseid
          ''',
            substitutionValues: {
              'facultyid': _data.facultyid,
              'courseid': val,
            },
          );
        });

        if (connection.isClosed) await initConnection();
        courseid.forEach((val) async {
          await connection.query(
            '''
          insert into faculty_course
          values (@facultyid, @courseid)
          on conflict (facultyid, courseid) do nothing
          ''',
            substitutionValues: {
              'facultyid': _data.facultyid,
              'courseid': val,
            },
          );
        });

        _data = Faculty(
          facultyid: _data.facultyid,
          email: _data.email,
          name: name,
          courseid: courseid,
        );
        notifyListeners();
      }
    } catch (error) {
      throw (error);
    }
  }

  Future<void> delete() async {
    if (connection.isClosed) await initConnection();
    try {
      await connection.query(
        '''
      delete
      from faculty
      where facultyid = @facultyid
      ''',
        substitutionValues: {
          'facultyid': _data.facultyid,
        },
      );
      _emailList.remove(_data.email);
      _data = null;
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Future<void> updatePassword(password) async {
    if (connection.isClosed) await initConnection();
    try {
      await connection.query(
        '''
      update faculty
      set password = crypt(@password, gen_salt('bf'))
      where facultyid = @facultyid
      ''',
        substitutionValues: {
          'facultyid': _data.facultyid,
          'password': password,
        },
      );
    } catch (error) {
      throw (error);
    }
  }

  void logout() {
    _data = null;
  }
}
