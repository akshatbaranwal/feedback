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

  List<String> get courseList {
    return [..._courseList];
  }

  Faculty get data {
    return Faculty(
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
      if (response.isNotEmpty) {
        final loadedCourses = [];
        response.forEach((val) {
          loadedCourses.add([val[0], val[1]]);
        });
        _courseList = loadedCourses;
        notifyListeners();
      }
    } catch (error) {
      throw (error);
    }
  }

  Future<void> fetchEmails() async {
    try {
      final response = await connection.query('''
      select email from faculty
      ''');
      if (response.isNotEmpty) {
        final loadedEmails = [];
        response.forEach((element) {
          loadedEmails.add(element[0]);
        });
        _emailList = loadedEmails;
        notifyListeners();
      }
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
      _data = Faculty(
        facultyid: response[0],
        email: response[1],
        name: response[2],
        courseid: response[3],
      );
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
      if (response.isNotEmpty) {
        _data = Faculty(
          facultyid: response[0][0],
          email: response[0][1],
          name: response[0][3],
          courseid: response[0][4],
        );
        notifyListeners();
      }
    } catch (error) {
      throw (error);
    }
  }

  Future<void> edit({
    @required id,
    @required password,
  }) async {
    try {
      await connection.query(
        '''
      update faculty
      set password = crypt(@password, gen_salt('bf'))
      where id = @id
      ''',
        substitutionValues: {
          'id': id,
          'password': password,
        },
      );
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }
}
