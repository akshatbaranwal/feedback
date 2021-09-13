import '../import.dart';

class Student {
  final int studentid;
  final String enroll;
  final String email;
  final String name;
  final int branchid;
  final int year;
  final int sem;

  Student({
    @required this.studentid,
    @required this.enroll,
    @required this.email,
    @required this.name,
    @required this.branchid,
    @required this.year,
    @required this.sem,
  });
}

class StudentData with ChangeNotifier {
  var _emailList = [];
  var _enrollList = [];
  var _branchList = [];
  Student _data;

  List<String> get emailList {
    return [..._emailList];
  }

  List<String> get enrollList {
    return [..._enrollList];
  }

  List<dynamic> get branchList {
    return [..._branchList];
  }

  Student get data {
    return _data == null
        ? null
        : Student(
            branchid: _data.branchid,
            email: _data.email,
            enroll: _data.enroll,
            name: _data.name,
            studentid: _data.studentid,
            year: _data.year,
            sem: (DateTime.now().month / 6 +
                    (DateTime.now().year - _data.year) * 2)
                .toInt(),
          );
  }

  void _updatePrefs(emailId, password) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("userType", "student");
    prefs.setString("emailId", emailId);
    prefs.setString("password", password);
  }

  Future<void> fetchBranches() async {
    if (connection.isClosed) await initConnection();
    try {
      final response = await connection.query('''
      select *
      from branch
      ''');
      final loadedBranches = [];
      if (response.isNotEmpty) {
        response.forEach((val) {
          loadedBranches.add([val[0], val[1]]);
        });
      }
      _branchList = loadedBranches;
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
      from student
      ''');
      final loadedEmails = [];
      if (response.isNotEmpty) {
        response.forEach((val) {
          loadedEmails.add(val[0]);
        });
      }
      _emailList = loadedEmails;
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Future<void> fetchEnrolls() async {
    if (connection.isClosed) await initConnection();
    try {
      final response = await connection.query('''
      select enroll
      from student
      ''');
      final loadedEnrolls = [];
      if (response.isNotEmpty) {
        response.forEach((val) {
          loadedEnrolls.add(val[0]);
        });
      }
      _enrollList = loadedEnrolls;
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
    select studentid, enroll, email, name, branchid, year, password
    from student
    where email = @email
    and password = crypt(@password, password)
    ''',
        substitutionValues: {
          'email': email,
          'password': password,
        },
      );
      Student temp;
      if (response.isNotEmpty) {
        temp = Student(
          studentid: response[0][0],
          enroll: response[0][1],
          email: response[0][2],
          name: response[0][3],
          branchid: response[0][4],
          year: response[0][5],
          sem: (DateTime.now().month / 6 +
                  (DateTime.now().year - response[0][5]) * 2)
              .toInt(),
        );
        _updatePrefs(email, response[0][6]);
        _data = temp;
      }
      notifyListeners();
    } catch (error) {
      print("error");
      throw (error);
    }
  }

  Future<void> autoLogin({
    @required email,
    @required password,
  }) async {
    if (connection.isClosed) await initConnection();
    try {
      final response = await connection.query(
        '''
    select studentid, enroll, email, name, branchid, year
    from student
    where email = @email
    and password = @password
    ''',
        substitutionValues: {
          'email': email,
          'password': password,
        },
      );
      Student temp;
      if (response.isNotEmpty) {
        temp = Student(
          studentid: response[0][0],
          enroll: response[0][1],
          email: response[0][2],
          name: response[0][3],
          branchid: response[0][4],
          year: response[0][5],
          sem: (DateTime.now().month / 6 +
                  (DateTime.now().year - response[0][5]) * 2)
              .toInt(),
        );
        _data = temp;
      }
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Future<void> register({
    @required enroll,
    @required email,
    @required name,
    @required password,
    @required branchid,
    @required year,
  }) async {
    if (connection.isClosed) await initConnection();
    try {
      final response = await connection.query(
        '''
    insert into student (enroll, email, password, name, branchid, year)
    values (@enroll, @email, crypt(@password, gen_salt('bf')), @name, @branchid, @year)
    returning *
    ''',
        substitutionValues: {
          'enroll': enroll,
          'email': email,
          'name': name,
          'password': password,
          'branchid': branchid,
          'year': year,
        },
      );
      Student temp;
      if (response.isNotEmpty) {
        temp = Student(
          studentid: response[0][0],
          enroll: response[0][1],
          email: response[0][2],
          name: response[0][4],
          branchid: response[0][5],
          year: response[0][6],
          sem: (DateTime.now().month / 6 +
                  (DateTime.now().year - response[0][6]) * 2)
              .toInt(),
        );
        _emailList.add(temp.email);
        _enrollList.add(temp.enroll);
        _updatePrefs(email, response[0][3]);
        _data = temp;
      }
      notifyListeners();
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
      from student
      where studentid = @studentid
      ''',
        substitutionValues: {
          'studentid': _data.studentid,
        },
      );
      _emailList.remove(_data.email);
      _enrollList.remove(_data.enroll);
      _data = null;
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Future<void> updateDetails({
    @required enroll,
    @required name,
    @required branchid,
    @required year,
  }) async {
    if (connection.isClosed) await initConnection();
    try {
      final response = await connection.query(
        '''
    update student
    set enroll = @enroll, 
        name = @name, 
        branchid = @branchid, 
        year = @year
    where studentid = @studentid
    returning *
    ''',
        substitutionValues: {
          'studentid': _data.studentid,
          'enroll': enroll,
          'name': name,
          'branchid': branchid,
          'year': year,
        },
      );
      if (response.isNotEmpty) {
        if (enroll != _data.enroll) {
          _enrollList.remove(enroll);
          _enrollList.add(enroll);
        }
        _data = Student(
          studentid: _data.studentid,
          enroll: response[0][1],
          email: _data.email,
          name: response[0][4],
          branchid: response[0][5],
          year: response[0][6],
          sem: (DateTime.now().month / 6 +
                  (DateTime.now().year - response[0][6]) * 2)
              .toInt(),
        );
        notifyListeners();
      }
    } catch (error) {
      throw (error);
    }
  }

  Future<void> updatePassword(password) async {
    if (connection.isClosed) await initConnection();
    try {
      final response = await connection.query(
        '''
      update student
      set password = crypt(@password, gen_salt('bf'))
      where studentid = @studentid
      returning *
      ''',
        substitutionValues: {
          'studentid': _data.studentid,
          'password': password,
        },
      );
      if (response.isNotEmpty) _updatePrefs(response[0][2], response[0][3]);
    } catch (error) {
      throw (error);
    }
  }

  void logout() {
    _data = null;
  }
}
