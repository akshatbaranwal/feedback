import 'package:feedback/import.dart';

class StudentDashboard extends StatefulWidget {
  static const routeName = '/student-dashboard';
  @override
  _StudentDashboardState createState() => _StudentDashboardState();
}

class _StudentDashboardState extends State<StudentDashboard> {
  bool _isInit = true;
  Type _type = Type.all;
  StudentData _student;
  int _indexBottomNavBar = 0;

  Future<void> _add() {
    return showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("It's a"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: _indexBottomNavBar == 0
              ? [
                  TextButton(
                    onPressed: () {
                      Navigator.of(ctx).popAndPushNamed(
                        AddNew.routeName,
                        arguments: {
                          'type': Type.opinion,
                          'from': User.student,
                        },
                      );
                    },
                    child: Text(
                      'Opinion',
                      style: TextStyle(fontSize: 17),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(ctx).popAndPushNamed(
                        AddNew.routeName,
                        arguments: {
                          'type': Type.request,
                          'from': User.student,
                        },
                      );
                    },
                    child: Text(
                      'Request',
                      style: TextStyle(fontSize: 17),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(ctx).popAndPushNamed(
                        AddNew.routeName,
                        arguments: {
                          'type': Type.query,
                          'from': User.student,
                        },
                      );
                    },
                    child: Text(
                      'Query',
                      style: TextStyle(fontSize: 17),
                    ),
                  ),
                ]
              : [
                  TextButton(
                    onPressed: () {
                      Navigator.of(ctx).popAndPushNamed(
                        AddNew.routeName,
                        arguments: {
                          'type': Type.feedback,
                          'from': User.student,
                        },
                      );
                    },
                    child: Text(
                      'Query',
                      style: TextStyle(fontSize: 17),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(ctx).popAndPushNamed(
                        AddNew.routeName,
                        arguments: {
                          'type': Type.rating,
                          'from': User.student,
                        },
                      );
                    },
                    child: Text(
                      'Feedback',
                      style: TextStyle(fontSize: 17),
                    ),
                  ),
                ],
        ),
      ),
    );
  }

  Future<void> _filterAdmin() async {
    return showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text('Filter'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextButton(
                onPressed: () {
                  setState(() {
                    _type = Type.all;
                  });
                  Navigator.of(context).pop();
                },
                child: Text(
                  'All',
                  style: TextStyle(fontSize: 17),
                ),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    _type = Type.opinion;
                  });
                  Navigator.of(context).pop();
                },
                child: Text(
                  'Opinion',
                  style: TextStyle(fontSize: 17),
                ),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    _type = Type.request;
                  });
                  Navigator.of(context).pop();
                },
                child: Text(
                  'Request',
                  style: TextStyle(fontSize: 17),
                ),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    _type = Type.query;
                  });
                  Navigator.of(context).pop();
                },
                child: Text(
                  'Query',
                  style: TextStyle(fontSize: 17),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _filterFaculty() {
    if (_type == Type.feedback)
      setState(() {
        _type = Type.rating;
      });
    else if (_type == Type.rating)
      setState(() {
        _type = Type.feedback;
      });
  }

  Future<void> _updateProfile() async {}

  @override
  void didChangeDependencies() {
    if (_isInit) {
      _student = Provider.of<StudentData>(context);
      Provider.of<AdminStudentList>(context).fetch(
        studentid: _student.data.studentid,
      );
      Provider.of<FacultyStudentList>(context).fetch(
        from: User.student,
        id: _student.data.studentid,
      );
      _isInit = false;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          _add();
        },
      ),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Hey ${_student.data.name.split(' ')[0]}!'),
        actions: [
          _indexBottomNavBar == 0
              ? IconButton(
                  onPressed: () async {
                    _filterAdmin();
                  },
                  icon: Icon(Icons.filter_alt),
                )
              : _type == Type.feedback
                  ? IconButton(
                      onPressed: _filterFaculty,
                      icon: Icon(Icons.star_rate),
                    )
                  : IconButton(
                      onPressed: _filterFaculty,
                      icon: Icon(Icons.feedback),
                    ),
          IconButton(
            onPressed: () async {
              _updateProfile();
            },
            icon: Icon(Icons.account_circle),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            label: 'Admin',
            icon: Container(),
          ),
          BottomNavigationBarItem(
            label: 'Faculty',
            icon: Container(),
          ),
        ],
        currentIndex: _indexBottomNavBar,
        onTap: (int index) {
          setState(() {
            _type = index == 0 ? Type.all : Type.feedback;
            _indexBottomNavBar = index;
          });
        },
        selectedLabelStyle: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: _indexBottomNavBar == 0
          ? StudentDashboardAdmin(_type)
          : StudentDashboardFaculty(_type),
    );
  }
}
