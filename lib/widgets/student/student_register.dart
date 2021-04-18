import '../../import.dart';

class StudentRegister extends StatefulWidget {
  @override
  _StudentRegisterState createState() => _StudentRegisterState();
}

class _StudentRegisterState extends State<StudentRegister> {
  final _form = GlobalKey<FormState>();
  bool _hidePassword = true;
  String _email, _password, _name, _enroll;
  int _year, _branchid;
  StudentData student;
  FacultyData faculty;
  AdminData admin;

  Future<void> _safeForm() async {
    final isValid = _form.currentState.validate();
    if (!isValid) return;
    _form.currentState.save();
    try {
      await student.register(
        branchid: _branchid,
        enroll: _enroll,
        year: _year,
        name: _name,
        email: _email,
        password: _password,
      );
      if (student.data == null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Invalid Password'),
        ));
      } else {
        Navigator.of(context).pushNamed(StudentDashboard.routeName);
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
              height: 15,
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
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Enrollment No.',
                hintText: 'Enrollment No.',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.account_balance),
              ),
              textInputAction: TextInputAction.next,
              validator: (enroll) {
                if (enroll.isEmpty) return 'Enter the enrollment number';
                return null;
              },
              onSaved: (enroll) {
                _enroll = enroll;
              },
            ),
            SizedBox(
              height: 15,
            ),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Start Year',
                hintText: 'Enter the year you joined college',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.timelapse),
              ),
              textInputAction: TextInputAction.next,
              validator: (year) {
                if (year.isEmpty) return 'Enter the year';
                if (int.parse(year) > DateTime.now().year)
                  return 'Are you time travelling?';
                return null;
              },
              onSaved: (year) {
                _year = int.parse(year);
              },
            ),
            SizedBox(
              height: 15,
            ),
            DropdownButtonFormField(
              items: student.branchList
                  .map((e) => DropdownMenuItem(
                        child: Text(e[1]),
                        value: e[0],
                      ))
                  .toList(),
              onChanged: (branch) {},
              decoration: InputDecoration(
                labelText: 'Branch',
                hintText: 'Choose your branch',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.school),
              ),
              validator: (branchid) {
                if (branchid == null) return 'Enter the branch';
                return null;
              },
              onSaved: (branchid) {
                _branchid = branchid;
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
