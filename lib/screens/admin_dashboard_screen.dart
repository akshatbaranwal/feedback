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
                  _admin.logout();
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
          title: Text('Hey Admin!'),
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
                onRefresh: () => _fetch(),
                child: _indexBottomNavBar == 0
                    ? AdminDashboardFaculty(_type[_indexBottomNavBar])
                    : AdminDashboardStudent(_type[_indexBottomNavBar]),
              ),
      ),
    );
  }
}
