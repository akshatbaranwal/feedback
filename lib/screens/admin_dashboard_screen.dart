import '../import.dart';

class AdminDashboard extends StatefulWidget {
  static const routeName = '/admin-dashboard';
  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  bool _isInit = true, _isLoading = false;
  List<Type> _type = [Type.all, Type.all];
  int _indexBottomNavBar = 0;
  AdminData _admin;
  Timer _timer;

  Future<void> _filter() async {
    return showDialog(
      context: context,
      builder: (ctx) {
        return Filter(
          type: _type[_indexBottomNavBar],
          callback: (type) => () {
            setState(() {
              _type[_indexBottomNavBar] = type;
            });
            Navigator.of(ctx).pop();
          },
        );
      },
    );
  }

  Future<void> _updateProfile() async {
    showDialog(
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
                    'user': User.admin,
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
                    builder: (_) => ConfirmDelete(_admin.delete),
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
    await Future.wait([
      Provider.of<AdminFacultyList>(context, listen: false).fetch(),
      Provider.of<AdminStudentList>(context, listen: false).fetch(),
      Provider.of<FacultyStudentList>(context, listen: false).fetch(
        from: User.admin,
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
    _admin = Provider.of<AdminData>(context);

    return WillPopScope(
      onWillPop: () async {
        return showDialog(
          context: context,
          builder: (_) => ConfirmExit(),
        );
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text('Admin'),
          actions: [
            if (_indexBottomNavBar == 0)
              IconButton(
                color: _type[0] == Type.rating ? Colors.white : Colors.white60,
                onPressed: () {
                  setState(() {
                    if (_type[0] == Type.rating)
                      _type[0] = Type.all;
                    else
                      _type[0] = Type.rating;
                  });
                },
                icon: Icon(Icons.analytics_outlined),
              ),
            IconButton(
              onPressed: () async {
                _filter();
              },
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
              label: 'Faculty',
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
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        body: _isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : RefreshIndicator(
                onRefresh: () async {
                  await _fetch();
                  if (_type[0] != Type.rating)
                    setState(() {
                      _type[0] = Type.all;
                    });
                  setState(() {
                    _type[1] = Type.all;
                  });
                },
                child: _indexBottomNavBar == 0
                    ? _type[_indexBottomNavBar] == Type.rating
                        ? GraphList()
                        : DiscussionList(
                            type: _type[_indexBottomNavBar],
                            from: User.admin,
                            to: User.faculty,
                          )
                    : DiscussionList(
                        type: _type[_indexBottomNavBar],
                        from: User.admin,
                        to: User.student,
                      ),
              ),
      ),
    );
  }
}
