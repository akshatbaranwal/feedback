import '../import.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = '/login-screen';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _login = true;
  User _user;

  Future<void> _chooseUser() {
    return showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text('Register as'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextButton(
                onPressed: () {
                  setState(() {
                    _login = false;
                    _user = User.student;
                  });
                  Navigator.of(context).pop();
                },
                child: Text(
                  'Student',
                  style: TextStyle(fontSize: 17),
                ),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    _login = false;
                    _user = User.faculty;
                  });
                  Navigator.of(context).pop();
                },
                child: Text(
                  'Faculty',
                  style: TextStyle(fontSize: 17),
                ),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    _login = false;
                    _user = User.admin;
                  });
                  Navigator.of(context).pop();
                },
                child: Text(
                  'Admin',
                  style: TextStyle(fontSize: 17),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return showDialog(
          context: context,
          builder: (_) => ConfirmExit(),
        );
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            _login
                ? 'Login'
                : _user == User.admin
                    ? 'Admin Register'
                    : _user == User.faculty
                        ? 'Faculty Register'
                        : 'Student Register',
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: _login
                  ? Login()
                  : _user == User.admin
                      ? AdminForm()
                      : _user == User.faculty
                          ? FacultyForm()
                          : StudentForm(),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(_login
                    ? "Don't have an account yet? "
                    : 'Already have an account? '),
                TextButton(
                  onPressed: _login
                      ? () {
                          _chooseUser();
                        }
                      : () {
                          setState(() {
                            _login = true;
                          });
                        },
                  child: Text(_login ? 'Register here' : 'Login here'),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}
