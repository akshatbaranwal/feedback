import '../../import.dart';

class FacultyForm extends StatefulWidget {
  @override
  _FacultyFormState createState() => _FacultyFormState();
}

class _FacultyFormState extends State<FacultyForm> {
  final _form = GlobalKey<FormState>();
  bool _hidePassword = true;
  String _email, _password, _name;
  List<int> _courseid;
  StudentData _student;
  FacultyData _faculty;
  AdminData _admin;
  bool _isNew, _isInit = true;

  Future<void> _safeForm() async {
    final isValid = _form.currentState.validate();
    if (!isValid) return;
    _form.currentState.save();
    try {
      if (_isNew)
        await _faculty.register(
          name: _name,
          courseid: _courseid,
          email: _email,
          password: _password,
        );
      else
        await _faculty.updateDetails(
          name: _name,
          courseid: _courseid,
        );
      if (_faculty.data == null) {
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
        Navigator.of(context).pushNamed(FacultyDashboard.routeName);
      }
    } catch (error) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Connection Error'),
        duration: Duration(seconds: 2),
      ));
    }
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      var data = Provider.of<FacultyData>(context, listen: false).data;
      if (data == null) {
        _courseid = [null];
        _isNew = true;
      } else {
        _courseid = data.courseid;
        _isNew = false;
      }
      _isInit = false;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    _student = Provider.of<StudentData>(context);
    _faculty = Provider.of<FacultyData>(context);
    _admin = Provider.of<AdminData>(context);

    return Form(
      key: _form,
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          SizedBox(
            height: 20,
          ),
          TextFormField(
            initialValue: _isNew ? '' : _faculty.data.name,
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
                if (_faculty.emailList.contains(email))
                  return 'Email already registered';
                if (_student.emailList.contains(email))
                  return 'Email registered as student';
                if (_admin.emailList.contains(email))
                  return 'Email registered as admin';
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
          ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: _courseid.length,
            itemBuilder: (ctx, index) {
              return Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField(
                          value: _courseid[index],
                          isExpanded: true,
                          isDense: false,
                          itemHeight: 50,
                          menuMaxHeight: 500,
                          items: _faculty.courseList
                              .map((e) => DropdownMenuItem(
                                    child: Text(e[1]),
                                    value: e[0],
                                  ))
                              .toList(),
                          onChanged: (courseid) {
                            setState(() {
                              _courseid[index] = courseid;
                            });
                          },
                          decoration: InputDecoration(
                            labelText: 'Course',
                            hintText: 'Choose your course',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.school),
                          ),
                          validator: (courseid) {
                            if (courseid == null) return 'Enter the course';
                            if (_courseid
                                    .where((element) => element == courseid)
                                    .length >
                                1) return 'Must be unique';
                            return null;
                          },
                          onSaved: (courseid) {
                            _courseid[index] = courseid;
                          },
                        ),
                      ),
                      if (_courseid.length > 1)
                        IconButton(
                          alignment: Alignment.centerRight,
                          onPressed: () {
                            setState(() {
                              _courseid.removeAt(index);
                            });
                          },
                          icon: Icon(Icons.delete),
                        ),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                ],
              );
            },
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _courseid.add(null);
              });
            },
            child: Text('Add Course'),
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
    );
  }
}
