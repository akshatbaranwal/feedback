import '../../import.dart';

class StudentForm extends StatefulWidget {
  @override
  _StudentFormState createState() => _StudentFormState();
}

class _StudentFormState extends State<StudentForm> {
  final _form = GlobalKey<FormState>();
  bool _hidePassword = true;
  String _email, _password, _name, _enroll;
  int _year, _branchid;
  StudentData _student;
  FacultyData _faculty;
  AdminData _admin;
  bool _isNew;

  Future<void> _safeForm() async {
    final isValid = _form.currentState.validate();
    if (!isValid) return;
    _form.currentState.save();
    try {
      if (_isNew)
        await _student.register(
          branchid: _branchid,
          enroll: _enroll,
          year: _year,
          name: _name,
          email: _email,
          password: _password,
        );
      else
        await _student.updateDetails(
          enroll: _enroll,
          name: _name,
          branchid: _branchid,
          year: _year,
        );
      if (_student.data == null) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Something went wrong'),
          duration: Duration(seconds: 2),
        ));
      } else {
        if (!_isNew) {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Update successful!'),
            duration: Duration(seconds: 2),
          ));
        }
        Navigator.of(context).pushNamed(StudentDashboard.routeName);
      }
    } catch (error) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Connection Error'),
          duration: Duration(seconds: 2),
        ),
      );
      throw error;
    }
  }

  @override
  Widget build(BuildContext context) {
    _student = Provider.of<StudentData>(context);
    _faculty = Provider.of<FacultyData>(context);
    _admin = Provider.of<AdminData>(context);
    _isNew = _student.data == null;

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: _form,
        child: ListView(
          children: [
            SizedBox(
              height: 15,
            ),
            TextFormField(
              initialValue: _isNew ? '' : _student.data.name,
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
            if (_isNew) ...[
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
                  if (_student.emailList.contains(email))
                    return 'Email already registered';
                  if (_admin.emailList.contains(email))
                    return 'Email registered as admin';
                  if (_faculty.emailList.contains(email))
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
            ],
            SizedBox(
              height: 15,
            ),
            TextFormField(
              initialValue: _isNew ? '' : _student.data.enroll,
              decoration: InputDecoration(
                labelText: 'Enrollment No.',
                hintText: 'Enrollment No.',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.account_balance),
              ),
              textInputAction: TextInputAction.next,
              validator: (enroll) {
                if (enroll.isEmpty) return 'Enter the enrollment number';
                if (_student.enrollList.contains(enroll))
                  return 'Already taken';
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
              initialValue: _isNew ? '' : _student.data.year.toString(),
              decoration: InputDecoration(
                labelText: 'Start Year',
                hintText: 'Enter the year you joined college',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.timelapse),
              ),
              textInputAction: TextInputAction.next,
              validator: (year) {
                if (year.isEmpty) return 'Enter the year';
                if (int.tryParse(year) == null) return 'Must be a number';
                if (int.parse(year) > DateTime.now().year)
                  return 'Are you time travelling?';
                if (int.parse(year) == DateTime.now().year &&
                    DateTime.now().month <= 6) {
                  return _isNew ? 'Semester 1 yet to start' : 'Invalid year';
                }
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
              value: _isNew ? null : _student.data.branchid,
              items: _student.branchList
                  .map((e) => DropdownMenuItem(
                        child: Text(e[1]),
                        value: e[0],
                      ))
                  .toList(),
              onChanged: (_) {},
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
              child: Text(_isNew ? 'Register' : 'Update'),
            ),
          ],
        ),
      ),
    );
  }
}
