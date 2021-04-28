import '../import.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _form = GlobalKey<FormState>();
  bool _hidePassword = true;
  String _email, _password;
  StudentData student;
  FacultyData faculty;
  AdminData admin;

  Future<void> _safeForm() async {
    final isValid = _form.currentState.validate();
    if (!isValid) return;
    _form.currentState.save();
    if (student.emailList.contains(_email)) {
      try {
        await student.login(
          email: _email,
          password: _password,
        );
        if (student.data == null) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Incorrect Password'),
          ));
        } else {
          Navigator.of(context).pushNamed(StudentDashboard.routeName);
        }
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Connection Error'),
        ));
      }
    } else if (faculty.emailList.contains(_email)) {
      try {
        await faculty.login(
          email: _email,
          password: _password,
        );
        if (faculty.data == null) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Incorrect Password'),
          ));
        } else {
          Navigator.of(context).pushNamed(FacultyDashboard.routeName);
        }
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Connection Error'),
        ));
      }
    } else {
      try {
        await admin.login(
          email: _email,
          password: _password,
        );
        if (admin.data == null) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Incorrect Password'),
          ));
        } else {
          Navigator.of(context).pushNamed(AdminDashboard.routeName);
        }
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Connection Error'),
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    student = Provider.of<StudentData>(context);
    faculty = Provider.of<FacultyData>(context);
    admin = Provider.of<AdminData>(context);
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: _form,
        child: ListView(
          children: [
            SizedBox(
              height: 20,
            ),
            TextFormField(
              initialValue: '',
              decoration: InputDecoration(
                labelText: 'Email',
                hintText: 'Enter college ID',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.email_outlined),
              ),
              textInputAction: TextInputAction.next,
              validator: (email) {
                if (email.isEmpty) return 'Enter the email';
                if (!email.endsWith('@iiita.ac.in'))
                  return 'Domain must be @iiita.ac.in';
                if (!student.emailList.contains(email) &&
                    !faculty.emailList.contains(email) &&
                    !admin.emailList.contains(email))
                  return 'Email not registered';
                return null;
              },
              onSaved: (email) {
                _email = email;
              },
            ),
            SizedBox(
              height: 20,
            ),
            TextFormField(
              initialValue: '',
              obscureText: _hidePassword,
              decoration: InputDecoration(
                labelText: 'Password',
                hintText: 'Enter your password',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.lock_outline),
                suffixIcon: IconButton(
                  icon: _hidePassword
                      ? Icon(Icons.visibility_off_outlined)
                      : Icon(Icons.visibility_outlined),
                  onPressed: () {
                    setState(() {
                      _hidePassword = !_hidePassword;
                    });
                  },
                ),
              ),
              textInputAction: TextInputAction.done,
              validator: (password) {
                if (password.isEmpty) return 'Enter the password';
                return null;
              },
              onSaved: (password) {
                _password = password;
              },
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () {
                _safeForm();
              },
              child: Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
