import 'package:feedback/import.dart';

class FacultyDashboard extends StatefulWidget {
  static const routeName = '/faculty-dashboard';
  @override
  _FacultyDashboardState createState() => _FacultyDashboardState();
}

class _FacultyDashboardState extends State<FacultyDashboard> {
  bool _isInit = true;
  Type _type = Type.all;
  FacultyData _faculty;
  int _indexBottomNavBar = 0;

  Future<void> _add() {
    return showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("It's a"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextButton(
              onPressed: () {
                Navigator.of(ctx).popAndPushNamed(
                  AddNew.routeName,
                  arguments: {
                    'type': Type.opinion,
                    'from': User.faculty,
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
                    'from': User.faculty,
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
                    'from': User.faculty,
                  },
                );
              },
              child: Text(
                'Query',
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

  void _filterStudent() {
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
      _faculty = Provider.of<FacultyData>(context);
      Provider.of<AdminFacultyList>(context).fetch(
        facultyid: _faculty.data.facultyid,
      );
      Provider.of<FacultyStudentList>(context).fetch(
        from: User.faculty,
        id: _faculty.data.facultyid,
      );
      _isInit = false;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: _indexBottomNavBar == 0
          ? FloatingActionButton(
              onPressed: () {
                _add();
              },
              child: Icon(Icons.add),
            )
          : null,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Hey ${_faculty.data.name.split(' ')[0]}!'),
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
                      onPressed: _filterStudent,
                      icon: Icon(Icons.star_rate),
                    )
                  : IconButton(
                      onPressed: _filterStudent,
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
            label: 'Student',
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
          ? FacultyDashboardAdmin(_type)
          : FacultyDashboardStudent(_type),
    );
  }
}
