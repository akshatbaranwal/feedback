import '../import.dart';

class AddNew extends StatefulWidget {
  static const routeName = '/add-new';
  @override
  _AddNewState createState() => _AddNewState();
}

class _AddNewState extends State<AddNew> {
  final _form = GlobalKey<FormState>();
  FacultyStudentList _facultyStudent;
  AdminFacultyList _adminFaculty;
  AdminStudentList _adminStudent;
  StudentData _student;
  FacultyData _faculty;
  User _from;
  Type _type;
  int _facultyid, _courseid;
  double _lecture, _demo, _slide, _lab, _syllabus, _interaction;
  String _subject, _body;
  bool _firstTime = false;

  Future<void> _saveForm() async {
    final isValid = _form.currentState.validate();
    if (!isValid) return;
    _form.currentState.save();
    if (_type == Type.feedback) {
      try {
        await _facultyStudent.add(
          sem: _student.data.sem,
          studentemail: _student.data.email,
          studentname: _student.data.name,
          facultyid: _facultyid,
          studentid: _student.data.studentid,
          subject: _subject,
          body: _body,
        );
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('query added!'),
          duration: Duration(seconds: 2),
        ));
        Navigator.of(context).pop();
      } catch (error) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Connection Error'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } else if (_from == User.student) {
      try {
        await _adminStudent.add(
          studentemail: _student.data.email,
          studentname: _student.data.name,
          sem: _student.data.sem,
          branch: _student.branchList
              .firstWhere((element) => element[0] == _student.data.branchid)[1],
          type: _type.toString().split('.').last,
          studentid: _student.data.studentid,
          subject: _subject,
          body: _body,
        );
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('${_type.toString().split('.').last} added!'),
          duration: Duration(seconds: 2),
        ));
        Navigator.of(context).pop();
      } catch (error) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Connection Error'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } else
      try {
        await _adminFaculty.add(
          facultyemail: _faculty.data.email,
          facultyname: _faculty.data.name,
          type: _type.toString().split('.').last,
          facultyid: _faculty.data.facultyid,
          subject: _subject,
          body: _body,
        );
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('${_type.toString().split('.').last} added!'),
          duration: Duration(seconds: 2),
        ));
        Navigator.of(context).pop();
      } catch (error) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Connection Error'),
            duration: Duration(seconds: 2),
          ),
        );
      }
  }

  Widget _formBuilder() {
    return Form(
      key: _form,
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          if (_type == Type.feedback) ...[
            DropdownButtonFormField(
              items: () {
                var k = _facultyStudent.ratings
                    .map((e) => '${e.facultyid}:${e.facultyname}')
                    .toSet()
                    .toList();
                return k.map((e) {
                  return DropdownMenuItem(
                    child: Text(e.split(':')[1]),
                    value: int.parse(e.split(':')[0]),
                  );
                }).toList();
              }(),
              onChanged: (_) {},
              decoration: InputDecoration(
                labelText: 'Faculty',
              ),
              validator: (facultyid) {
                if (facultyid == null) return 'Which faculty?';
                return null;
              },
              onSaved: (facultyid) {
                _facultyid = facultyid;
              },
            ),
            SizedBox(
              height: 10,
            ),
          ],
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Subject',
            ),
            validator: (subject) {
              if (subject.isEmpty) return 'Enter the subject';
              return null;
            },
            onSaved: (subject) {
              _subject = subject;
            },
          ),
          SizedBox(height: 15),
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Body',
            ),
            maxLines: 5,
            validator: (body) {
              if (body.isEmpty) return 'Enter the body';
              return null;
            },
            onSaved: (body) {
              _body = body;
            },
          ),
          ElevatedButton.icon(
            onPressed: _saveForm,
            icon: Icon(Icons.send),
            label: Text('Send'),
          ),
        ],
      ),
    );
  }

  Future<void> _saveRating() async {
    final isValid = _form.currentState.validate();
    if (!isValid) return;
    _form.currentState.save();
    try {
      await _facultyStudent.updateRating(
        facultyid: _facultyid,
        studentid: _student.data.studentid,
        lecture: _lecture,
        demo: _demo,
        slide: _slide,
        lab: _lab,
        syllabus: _syllabus,
        interaction: _interaction,
        courseid: _courseid,
      );
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Rating updated!'),
        duration: Duration(seconds: 2),
      ));
      Navigator.of(context).pop();
    } catch (error) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Connection Error'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  Widget _slider(category, val, fn) {
    return Column(
      children: [
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "  $category",
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            Slider(
              value: val,
              min: 0,
              max: 100,
              divisions: 100,
              label: val.toString(),
              onChanged: fn,
            ),
          ],
        ),
      ],
    );
  }

  Widget _ratingBuilder() {
    return Form(
      key: _form,
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          DropdownButtonFormField(
            isExpanded: true,
            isDense: false,
            items: _facultyStudent.ratings
                .map(
                  (e) => DropdownMenuItem(
                    child: Column(
                      children: [
                        Row(children: [Text(e.facultyname)]),
                        Row(children: [
                          Text(
                            e.coursename,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.black38,
                              fontSize: 12,
                            ),
                          ),
                        ]),
                      ],
                    ),
                    value: '${e.facultyid}:${e.courseid}',
                  ),
                )
                .toList(),
            onChanged: (id) {
              setState(() {
                _facultyid = int.parse(id.split(':')[0]);
                _courseid = int.parse(id.split(':')[1]);
                int _index = _facultyStudent.ratings.indexWhere((element) =>
                    element.facultyid == _facultyid &&
                    element.courseid == _courseid);
                _lecture = _facultyStudent.ratings[_index].lecture ?? 50;
                _demo = _facultyStudent.ratings[_index].demo ?? 50;
                _slide = _facultyStudent.ratings[_index].slide ?? 50;
                _lab = _facultyStudent.ratings[_index].lab ?? 50;
                _syllabus = _facultyStudent.ratings[_index].syllabus ?? 50;
                _interaction =
                    _facultyStudent.ratings[_index].interaction ?? 50;
                _firstTime = _facultyStudent.ratings[_index].lecture == null;
              });
            },
            decoration: InputDecoration(
              labelText: 'Faculty',
            ),
            validator: (id) {
              if (id == null) return 'Which faculty?';
              return null;
            },
          ),
          SizedBox(
            height: 20,
          ),
          if (_facultyid != null)
            Column(
              children: [
                _slider('Lecture', _lecture, (value) {
                  setState(() {
                    _lecture = value;
                  });
                }),
                _slider('Demo', _demo, (value) {
                  setState(() {
                    _demo = value;
                  });
                }),
                _slider('Slides', _slide, (value) {
                  setState(() {
                    _slide = value;
                  });
                }),
                _slider('Lab', _lab, (value) {
                  setState(() {
                    _lab = value;
                  });
                }),
                _slider('Syllabus', _syllabus, (value) {
                  setState(() {
                    _syllabus = value;
                  });
                }),
                _slider('Interaction', _interaction, (value) {
                  setState(() {
                    _interaction = value;
                  });
                }),
                SizedBox(height: 10),
                ElevatedButton.icon(
                  onPressed: _saveRating,
                  icon: Icon(Icons.done),
                  label: Text(_firstTime ? 'Add' : 'Update'),
                ),
              ],
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _student = Provider.of<StudentData>(context);
    _faculty = Provider.of<FacultyData>(context);
    _facultyStudent = Provider.of<FacultyStudentList>(context);
    _adminFaculty = Provider.of<AdminFacultyList>(context);
    _adminStudent = Provider.of<AdminStudentList>(context);

    final args =
        ModalRoute.of(context).settings.arguments as Map<String, Object>;
    _type = args['type'];
    _from = args['from'];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _type == Type.rating
              ? 'Add feedback'
              : _type == Type.feedback
                  ? 'Add query'
                  : 'Add ${_type.toString().split('.').last}',
        ),
      ),
      body: _type == Type.rating ? _ratingBuilder() : _formBuilder(),
    );
  }
}
