import '../import.dart';

class StudentDashboard extends StatefulWidget {
  static const routeName = '/student-dashboard';
  @override
  _StudentDashboardState createState() => _StudentDashboardState();
}

class _StudentDashboardState extends State<StudentDashboard> {
  bool _isInit = true, _isLoading = false;
  Type _type = Type.all;
  StudentData _student;
  int _indexBottomNavBar = 0;
  PageController _pageController = PageController(
    initialPage: 0,
    keepPage: true,
  );
  Timer _timer;

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
        return Filter(
          type: _type,
          callback: (type) => () {
            setState(() {
              _type = type;
            });
            Navigator.of(ctx).pop();
          },
        );
      },
    );
  }

  Future<void> _updateProfile() async {
    return showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text('Account'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.of(ctx)
                      .popAndPushNamed(UpdateAccount.routeName, arguments: {
                    'user': User.student,
                    'password': false,
                  });
                },
                child: Text(
                  'Update Details',
                  style: TextStyle(fontSize: 17),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(ctx)
                      .popAndPushNamed(UpdateAccount.routeName, arguments: {
                    'user': User.student,
                    'password': true,
                  });
                },
                child: Text(
                  'Change Password',
                  style: TextStyle(fontSize: 17),
                ),
              ),
              TextButton(
                onPressed: () {
                  logOut(ctx);
                },
                child: Text(
                  'Log out',
                  style: TextStyle(fontSize: 17),
                ),
              ),
              TextButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (_) => ConfirmDelete(_student.delete),
                  );
                },
                child: Text(
                  'Delete Account',
                  style: TextStyle(
                    fontSize: 17,
                    color: Colors.red,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _fetch() async {
    int id = Provider.of<StudentData>(context, listen: false).data.studentid;
    await Future.wait([
      Provider.of<AdminStudentList>(context, listen: false).fetch(
        studentid: id,
      ),
      Provider.of<FacultyStudentList>(context, listen: false).fetch(
        from: User.student,
        id: id,
      ),
    ]);
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      _fetch().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
      _timer = Timer.periodic(
        Duration(seconds: 10),
        (_) => _fetch(),
      );
      _isInit = false;
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _student = Provider.of<StudentData>(context);

    return WillPopScope(
      onWillPop: () async {
        return showDialog(
          context: context,
          builder: (_) => ConfirmExit(),
        );
      },
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: _add,
        ),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text('Hey ${_student.data.name.split(' ')[0]}!'),
          actions: [
            if (_indexBottomNavBar == 0)
              IconButton(
                onPressed: _filterAdmin,
                icon: Icon(Icons.filter_alt),
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
              _pageController.animateToPage(
                index,
                duration: Duration(milliseconds: 300),
                curve: Curves.slowMiddle,
              );
              _indexBottomNavBar = index;
            });
          },
          selectedLabelStyle: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
        body: _isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _indexBottomNavBar = index;
                  });
                },
                children: [
                  RefreshIndicator(
                    onRefresh: () async {
                      await _fetch();
                      setState(() {
                        _type = Type.all;
                      });
                    },
                    child: DiscussionList(
                      type: _type,
                      from: User.student,
                      to: User.admin,
                    ),
                  ),
                  RefreshIndicator(
                    onRefresh: () async {
                      await _fetch();
                      setState(() {
                        _type = Type.all;
                      });
                    },
                    child: DiscussionList(
                      from: User.student,
                      to: User.faculty,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
