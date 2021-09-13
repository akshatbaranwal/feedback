import '../import.dart';

class Loading extends StatefulWidget {
  static const routeName = '/';
  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  double _progress;
  bool _isInit = true, _noInternet = true;
  Random _random = Random();
  String _msg = "Waiting for internet connection...";
  StudentData student;
  FacultyData faculty;
  AdminData admin;

  void _autoLoginFailed() {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Automatice Login Failed'),
      duration: Duration(seconds: 2),
    ));
  }

  Future<void> _autoLogin() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var userType = prefs.getString("userType");
    var email = prefs.getString("emailId");
    var password = prefs.getString("password");

    if (userType == "student") {
      try {
        await student.autoLogin(
          email: email,
          password: password,
        );
        if (student.data == null) {
          _autoLoginFailed();
        } else {
          await Navigator.of(context).pushNamed(StudentDashboard.routeName);
        }
      } catch (error) {
        _autoLoginFailed();
      }
    } else if (userType == "faculty") {
      try {
        await faculty.autoLogin(
          email: email,
          password: password,
        );
        if (faculty.data == null) {
          _autoLoginFailed();
        } else {
          await Navigator.of(context).pushNamed(FacultyDashboard.routeName);
        }
      } catch (error) {
        _autoLoginFailed();
      }
    } else if (userType == "admin") {
      try {
        await admin.autoLogin(
          email: email,
          password: password,
        );
        if (admin.data == null) {
          _autoLoginFailed();
        } else {
          await Navigator.of(context).pushNamed(AdminDashboard.routeName);
        }
      } catch (error) {
        _autoLoginFailed();
      }
    }
  }

  Future<void> _connect() async {
    while (_noInternet) {
      _noInternet = false;
      try {
        await initConnection();
      } catch (error) {
        _noInternet = true;
        await Future.delayed(Duration(seconds: 1));
      }
    }
    // setState(() {
    //   _progress = 0;
    //   _msg = funnyLoadingMessages[_random.nextInt(funnyLoadingMessages.length)];
    // });
    Provider.of<StudentData>(context, listen: false).fetchEmails();
    Provider.of<FacultyData>(context, listen: false).fetchEmails();
    Provider.of<AdminData>(context, listen: false).fetchEmails();
    Provider.of<StudentData>(context, listen: false).fetchBranches();
    Provider.of<StudentData>(context, listen: false).fetchEnrolls();
    Provider.of<FacultyData>(context, listen: false).fetchCourses();
    // await Future.wait([
    //   Provider.of<StudentData>(context, listen: false)
    //       .fetchEmails()
    //       .then((value) {
    //     setState(() {
    //       _progress += 0.15;
    //     });
    //   }),
    //   Provider.of<FacultyData>(context, listen: false)
    //       .fetchEmails()
    //       .then((value) {
    //     setState(() {
    //       _progress += 0.15;
    //     });
    //   }),
    //   Provider.of<AdminData>(context, listen: false)
    //       .fetchEmails()
    //       .then((value) {
    //     setState(() {
    //       _progress += 0.15;
    //     });
    //   }),
    //   Provider.of<StudentData>(context, listen: false)
    //       .fetchBranches()
    //       .then((value) {
    //     setState(() {
    //       _progress += 0.15;
    //     });
    //   }),
    //   Provider.of<StudentData>(context, listen: false)
    //       .fetchEnrolls()
    //       .then((value) {
    //     setState(() {
    //       _progress += 0.15;
    //     });
    //   }),
    //   Provider.of<FacultyData>(context, listen: false)
    //       .fetchCourses()
    //       .then((value) {
    //     setState(() {
    //       _progress += 0.15;
    //     });
    //   }),
    // ]);
    // setState(() {
    //   _progress = 1;
    // });
    await _autoLogin();
    await Navigator.of(context).pushNamed(LoginScreen.routeName);
    await connection.close();
    SystemNavigator.pop();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      _msg = funnyLoadingMessages[_random.nextInt(funnyLoadingMessages.length)];
      _connect();
      _isInit = false;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    student = Provider.of<StudentData>(context, listen: false);
    faculty = Provider.of<FacultyData>(context, listen: false);
    admin = Provider.of<AdminData>(context, listen: false);
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 30),
          Expanded(
            child: Center(
              child: Text(
                'Feedback\nManagement\nSystem',
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 40,
              vertical: 20,
            ),
            child: Text(
              _msg,
              maxLines: 5,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
          SizedBox(
            height: 2,
            width: 150,
            child: LinearProgressIndicator(
              value: _progress,
            ),
          ),
          SizedBox(height: 50),
        ],
      ),
    );
  }
}
