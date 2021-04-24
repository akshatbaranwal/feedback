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
  int _facultyid, _lecture, _demo, _slide, _lab, _syllabus, _interaction;
  String _subject, _body, _comment;

  Future<void> _saveForm() async {
    final isValid = _form.currentState.validate();
    if (!isValid) return;
    _form.currentState.save();
    if (_type == Type.feedback) {
      try {
        await _facultyStudent.add(
          facultyid: _facultyid,
          studentid: _student.data.studentid,
          subject: _subject,
          body: _body,
        );
        Navigator.of(context).pop();
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Connection Error'),
          ),
        );
      }
    } else if (_from == User.student) {
      try {
        await _adminStudent.add(
          type: _type.toString().split('.').last,
          studentid: _student.data.studentid,
          subject: _subject,
          body: _body,
        );
        Navigator.of(context).pop();
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Connection Error'),
          ),
        );
      }
    } else
      try {
        await _adminFaculty.add(
          type: _type.toString().split('.').last,
          facultyid: _faculty.data.facultyid,
          subject: _subject,
          body: _body,
        );
        Navigator.of(context).pop();
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Connection Error'),
          ),
        );
      }
  }

  Widget _formBuilder() {
    return Form(
      key: _form,
      child: ListView(
        children: [
          if (_type == Type.feedback) ...[
            DropdownButtonFormField(
              items: _facultyStudent.ratings.map((e) {
                return DropdownMenuItem(
                  child: Text(e.name),
                  value: e.facultyid,
                );
              }).toList(),
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
        comment: _comment,
      );
      Navigator.of(context).pop();
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Connection Error'),
        ),
      );
    }
  }

  Widget _ratingBuilder() {
    return ListView(
      children: [
        DropdownButtonFormField(
          items: _facultyStudent.ratings.map((e) {
            return DropdownMenuItem(
              child: Text(e.name),
              value: e.facultyid,
            );
          }).toList(),
          onChanged: (facultyid) {
            setState(() {
              _facultyid = facultyid;
              int _index = _facultyStudent.ratings
                  .indexWhere((element) => element.facultyid == facultyid);
              _lecture = _facultyStudent.ratings[_index].lecture ?? 50 ?? 50;
              _demo = _facultyStudent.ratings[_index].demo ?? 50;
              _slide = _facultyStudent.ratings[_index].slide ?? 50;
              _lab = _facultyStudent.ratings[_index].lab ?? 50;
              _syllabus = _facultyStudent.ratings[_index].syllabus ?? 50;
              _interaction = _facultyStudent.ratings[_index].interaction ?? 50;
              _comment = _facultyStudent.ratings[_index].comment ?? 'none';
            });
          },
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
          height: 20,
        ),
        if (_facultyid != null)
          Column(
            children: [
              Text(
                'Lecture: $_lecture',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              Slider(
                value: _lecture.toDouble(),
                min: 0,
                max: 100,
                divisions: 100,
                label: _lecture.toString(),
                onChanged: (value) {
                  setState(() {
                    _lecture = value.toInt();
                  });
                },
              ),
              Text(
                'Demo $_demo',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              Slider(
                value: _demo.toDouble(),
                min: 0,
                max: 100,
                divisions: 100,
                label: _demo.toString(),
                onChanged: (value) {
                  setState(() {
                    _demo = value.toInt();
                  });
                },
              ),
              Text(
                'Slides: $_slide',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              Slider(
                value: _slide.toDouble(),
                min: 0,
                max: 100,
                divisions: 100,
                label: _slide.toString(),
                onChanged: (value) {
                  setState(() {
                    _slide = value.toInt();
                  });
                },
              ),
              Text(
                'Lab: $_lab',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              Slider(
                value: _lab.toDouble(),
                min: 0,
                max: 100,
                divisions: 100,
                label: _lab.toString(),
                onChanged: (value) {
                  setState(() {
                    _lab = value.toInt();
                  });
                },
              ),
              Text(
                'Syllabus: $_syllabus',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              Slider(
                value: _syllabus.toDouble(),
                min: 0,
                max: 100,
                divisions: 100,
                label: _syllabus.toString(),
                onChanged: (value) {
                  setState(() {
                    _syllabus = value.toInt();
                  });
                },
              ),
              Text(
                'Interaction: $_interaction',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              Slider(
                value: _interaction.toDouble(),
                min: 0,
                max: 100,
                divisions: 100,
                label: _interaction.toString(),
                onChanged: (value) {
                  setState(() {
                    _interaction = value.toInt();
                  });
                },
              ),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Optional Comment',
                ),
                keyboardType: TextInputType.multiline,
                onChanged: (comment) {
                  setState(() {
                    _comment = comment;
                  });
                },
              ),
              ElevatedButton.icon(
                onPressed: _saveRating,
                icon: Icon(Icons.done),
                label: Text('Update'),
              ),
            ],
          ),
      ],
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
        title: Text('Add ${_type.toString().split('.').last}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: _type == Type.rating ? _ratingBuilder() : _formBuilder(),
      ),
    );
  }
}
