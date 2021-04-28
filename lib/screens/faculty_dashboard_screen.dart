import '../import.dart';

class FacultyDashboard extends StatefulWidget {
  static const routeName = '/faculty-dashboard';
  @override
  _FacultyDashboardState createState() => _FacultyDashboardState();
}

class _FacultyDashboardState extends State<FacultyDashboard> {
  bool _isInit = true, _isLoading = false;
  List<Type> _type = [Type.all, Type.feedback];
  FacultyData _faculty;
  List<FacultyRating> _rating;
  int _indexBottomNavBar = 0;
  Timer _timer;

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
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith((_) {
                    if (_type[_indexBottomNavBar] == Type.all)
                      return Theme.of(context)
                          .colorScheme
                          .primary
                          .withOpacity(0.1);
                    else
                      return null;
                  }),
                ),
                onPressed: () {
                  setState(() {
                    _type[_indexBottomNavBar] = Type.all;
                  });
                  Navigator.of(ctx).pop();
                },
                child: Text(
                  'All',
                  style: TextStyle(fontSize: 17),
                ),
              ),
              TextButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith((_) {
                    if (_type[_indexBottomNavBar] == Type.opinion)
                      return Theme.of(context)
                          .colorScheme
                          .primary
                          .withOpacity(0.1);
                    else
                      return null;
                  }),
                ),
                onPressed: () {
                  setState(() {
                    _type[_indexBottomNavBar] = Type.opinion;
                  });
                  Navigator.of(ctx).pop();
                },
                child: Text(
                  'Opinion',
                  style: TextStyle(fontSize: 17),
                ),
              ),
              TextButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith((_) {
                    if (_type[_indexBottomNavBar] == Type.request)
                      return Theme.of(context)
                          .colorScheme
                          .primary
                          .withOpacity(0.1);
                    else
                      return null;
                  }),
                ),
                onPressed: () {
                  setState(() {
                    _type[_indexBottomNavBar] = Type.request;
                  });
                  Navigator.of(ctx).pop();
                },
                child: Text(
                  'Request',
                  style: TextStyle(fontSize: 17),
                ),
              ),
              TextButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith((_) {
                    if (_type[_indexBottomNavBar] == Type.query)
                      return Theme.of(context)
                          .colorScheme
                          .primary
                          .withOpacity(0.1);
                    else
                      return null;
                  }),
                ),
                onPressed: () {
                  setState(() {
                    _type[_indexBottomNavBar] = Type.query;
                  });
                  Navigator.of(ctx).pop();
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
                    'user': User.faculty,
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
                    'user': User.faculty,
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
                  _faculty.logout();
                  Navigator.of(ctx)
                      .popUntil(ModalRoute.withName(LoginScreen.routeName));
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
                    builder: (_) => ConfirmDelete(_faculty.delete),
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
    int id = Provider.of<FacultyData>(context, listen: false).data.facultyid;
    await Future.wait([
      Provider.of<AdminFacultyList>(context, listen: false).fetch(
        facultyid: id,
      ),
      Provider.of<FacultyStudentList>(context, listen: false).fetch(
        from: User.faculty,
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
        Duration(seconds: 5),
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
    _rating = Provider.of<FacultyStudentList>(context).ratings;
    _faculty = Provider.of<FacultyData>(context);

    return WillPopScope(
      onWillPop: () async {
        return showDialog(
          context: context,
          builder: (_) => ConfirmExit(),
        );
      },
      child: Scaffold(
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
            if (_indexBottomNavBar == 0)
              IconButton(
                onPressed: () async {
                  _filterAdmin();
                },
                icon: Icon(Icons.filter_alt),
              ),
            IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (ctx) => Dialog(
                    insetPadding: const EdgeInsets.all(10),
                    child: _rating.length == 0
                        ? Container(
                            height: 100,
                            child: Center(
                              child: Text(
                                'No ratings yet.',
                                style: TextStyle(
                                  fontSize: 17,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ),
                          )
                        : Graph(_rating[0]),
                  ),
                );
              },
              icon: Icon(
                Icons.analytics_outlined,
              ),
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
            : RefreshIndicator(
                onRefresh: () => _fetch(),
                child: _indexBottomNavBar == 0
                    ? FacultyDashboardAdmin(_type[_indexBottomNavBar])
                    : FacultyDashboardStudent(),
              ),
      ),
    );
  }
}
