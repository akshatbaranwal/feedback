import '../../import.dart';

class AdminRegister extends StatefulWidget {
  @override
  _AdminRegisterState createState() => _AdminRegisterState();
}

class _AdminRegisterState extends State<AdminRegister> {
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
    try {
      await admin.register(
        email: _email,
        password: _password,
      );
      if (admin.data == null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Invalid Password'),
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

  @override
  Widget build(BuildContext context) {
    student = Provider.of<StudentData>(context);
    faculty = Provider.of<FacultyData>(context);
    admin = Provider.of<AdminData>(context);
    return Padding(
      padding: EdgeInsets.all(20),
      child: Form(
        key: _form,
        child: ListView(
          children: [
            SizedBox(
              height: 20,
            ),
            TextFormField(
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
                if (admin.emailList.contains(email))
                  return 'Email already registered';
                if (faculty.emailList.contains(email))
                  return 'Email registered as faculty';
                if (student.emailList.contains(email))
                  return 'Email registered as student';
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
              onFieldSubmitted: (_) {
                _safeForm();
              },
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () {
                _safeForm();
              },
              child: Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
}
