import '../import.dart';

class FacultyDashboard extends StatefulWidget {
  static const routeName = '/faculty-dashboard';
  @override
  _FacultyDashboardState createState() => _FacultyDashboardState();
}

class _FacultyDashboardState extends State<FacultyDashboard> {
  bool _isInit = true, _isLoading = false;
  Type _type = Type.all;
  FacultyData _faculty;
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
        content: Container(
          height: 150,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: TextButton(
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
              ),
              Expanded(
                child: TextButton(
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
              ),
              Expanded(
                child: TextButton(
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
              ),
            ],
          ),
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

  Future<void> _onRefresh() async {
    await _fetch();
    setState(() {
      _type = Type.all;
    });
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
          title: Text(_faculty.data.name),
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
                    child: Container(
                      height: 400,
                      child: GraphList(_onRefresh),
                    ),
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
              _pageController.jumpToPage(index);
              _indexBottomNavBar = index;
            });
          },
          selectedLabelStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        body: _isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : PageView(
                physics: CustomPageViewScrollPhysics(),
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _indexBottomNavBar = index;
                  });
                },
                children: [
                  DiscussionList(
                    onRefresh: _onRefresh,
                    type: _type,
                    from: User.faculty,
                    to: User.admin,
                  ),
                  DiscussionList(
                    onRefresh: _onRefresh,
                    from: User.faculty,
                    to: User.student,
                  ),
                ],
              ),
      ),
    );
  }
}
