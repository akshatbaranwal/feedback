import '../../import.dart';

class FacultyRegister extends StatefulWidget {
  @override
  _FacultyRegisterState createState() => _FacultyRegisterState();
}

class _FacultyRegisterState extends State<FacultyRegister> {
  final _form = GlobalKey<FormState>();
  bool _hidePassword = true;
  String _email, _password, _name, _courseid;
  StudentData student;
  FacultyData faculty;
  AdminData admin;

  Future<void> _safeForm() async {
    final isValid = _form.currentState.validate();
    if (!isValid) return;
    _form.currentState.save();
    try {
      await faculty.register(
        name: _name,
        courseid: _courseid,
        email: _email,
        password: _password,
      );
      if (faculty.data == null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Invalid Password'),
        ));
      } else {
        Navigator.of(context).pushNamed(FacultyDashboard.routeName);
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
                labelText: 'Name',
                hintText: 'Enter your full name',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
              textInputAction: TextInputAction.next,
              validator: (name) {
                if (name.isEmpty) return 'Enter your name';
                return null;
              },
              onSaved: (name) {
                _name = name;
              },
            ),
            SizedBox(
              height: 15,
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
                if (student.emailList.contains(email))
                  return 'Email already registered';
                if (admin.emailList.contains(email))
                  return 'Email registered as admin';
                if (faculty.emailList.contains(email))
                  return 'Email registered as faculty';
                return null;
              },
              onSaved: (email) {
                _email = email;
              },
            ),
            SizedBox(
              height: 15,
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
              textInputAction: TextInputAction.next,
              validator: (password) {
                if (password.isEmpty) return 'Enter the password';
                return null;
              },
              onSaved: (password) {
                _password = password;
              },
            ),
            SizedBox(
              height: 15,
            ),
            DropdownButtonFormField(
              isExpanded: true,
              isDense: false,
              itemHeight: 50,
              menuMaxHeight: 500,
              items: faculty.courseList
                  .map((e) => DropdownMenuItem(
                        child: Text(e[1]),
                        value: e[0],
                      ))
                  .toList(),
              onChanged: (_) {},
              decoration: InputDecoration(
                labelText: 'Course',
                hintText: 'Choose your course',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.school),
              ),
              validator: (courseid) {
                if (courseid == null) return 'Enter the course';
                return null;
              },
              onSaved: (courseid) {
                _courseid = courseid;
              },
            ),
            SizedBox(
              height: 15,
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
