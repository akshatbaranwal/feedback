import '../import.dart';

class Faculty {
  final int facultyid;
  final String email;
  final String name;
  final int courseid;

  Faculty({
    @required this.facultyid,
    @required this.email,
    @required this.name,
    @required this.courseid,
  });
}

class FacultyData with ChangeNotifier {
  final connection;
  FacultyData(this.connection);

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
    try {
      final response = await connection.query('''
      select email from faculty
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
    try {
      final response = await connection.query(
        '''
    select facultyid, email, name, courseid
    from faculty
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
        temp = Faculty(
          facultyid: response[0][0],
          email: response[0][1],
          name: response[0][2],
          courseid: response[0][3],
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
    try {
      final response = await connection.query(
        '''
    insert into faculty (email, password, name, courseid)
    values (@email, crypt(@password, gen_salt('bf')), @name, @courseid)
    returning *
    ''',
        substitutionValues: {
          'email': email,
          'password': password,
          'name': name,
          'courseid': courseid,
        },
      );
      Faculty temp;
      if (response.isNotEmpty) {
        temp = Faculty(
          facultyid: response[0][0],
          email: response[0][1],
          name: response[0][3],
          courseid: response[0][4],
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
    @required courseid,
  }) async {
    try {
      final response = await connection.query(
        '''
    update faculty
    set name = @name,
        courseid = @courseid
    where facultyid = @facultyid
    returning *
    ''',
        substitutionValues: {
          'name': name,
          'facultyid': _data.facultyid,
          'courseid': courseid,
        },
      );
      if (response.isNotEmpty) {
        _data = Faculty(
          facultyid: _data.facultyid,
          email: _data.email,
          name: response[0][3],
          courseid: response[0][4],
        );
        notifyListeners();
      }
    } catch (error) {
      throw (error);
    }
  }

  Future<void> delete() async {
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
