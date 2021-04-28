import '../import.dart';

class AdminDashboard extends StatefulWidget {
  static const routeName = '/admin-dashboard';
  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  bool _isInit = true, _isLoading = false;
  Type _type = Type.all;
  int _indexBottomNavBar = 0;
  AdminData _admin;
  AdminFacultyList _adminFaculty;
  AdminStudentList _adminStudent;
  FacultyStudentList _facultyStudent;

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
                onPressed: () {
                  setState(() {
                    _type = Type.all;
                  });
                  Navigator.of(ctx).pop();
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
                  Navigator.of(ctx).pop();
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
                  Navigator.of(ctx).pop();
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
                  Navigator.of(ctx).pop();
                },
                child: Text(
                  'Query',
                  style: TextStyle(fontSize: 17),
                ),
              ),
              if (_indexBottomNavBar == 0) ...[
                SizedBox(height: 10),
                Divider(),
                SizedBox(height: 10),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _type = Type.rating;
                    });
                    Navigator.of(ctx).pop();
                  },
                  child: Text(
                    'Performance',
                    style: TextStyle(fontSize: 17),
                  ),
                ),
              ],
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
                  _admin.delete();
                  Navigator.of(ctx)
                      .popUntil(ModalRoute.withName(LoginScreen.routeName));
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

  Future<void> _initialFetch() async {
    await Provider.of<AdminFacultyList>(context, listen: false).fetch();
    await Provider.of<AdminStudentList>(context, listen: false).fetch();
    await Provider.of<FacultyStudentList>(context, listen: false).fetch(
      from: User.admin,
    );
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      _initialFetch();
      _isInit = false;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    _admin = Provider.of<AdminData>(context);
    _adminFaculty = Provider.of<AdminFacultyList>(context);
    _adminStudent = Provider.of<AdminStudentList>(context);
    _facultyStudent = Provider.of<FacultyStudentList>(context);

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
              _type = Type.all;
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
                  await Future.wait(
                    [
                      _adminFaculty.fetch(),
                      _adminStudent.fetch(),
                      _facultyStudent.fetch(
                        from: User.admin,
                      ),
                    ],
                  );
                },
                child: _indexBottomNavBar == 0
                    ? AdminDashboardFaculty(_type)
                    : AdminDashboardStudent(_type),
              ),
      ),
    );
  }
}
