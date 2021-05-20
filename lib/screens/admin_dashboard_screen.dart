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
  PageController _pageController = PageController(
    initialPage: 0,
    keepPage: true,
  );
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
        return Profile(User.admin);
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

  Future<void> _onRefresh() async {
    await _fetch();
    if (_type[0] != Type.rating)
      setState(() {
        _type[0] = Type.all;
      });
    setState(() {
      _type[1] = Type.all;
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
                onPressed: () {
                  setState(() {
                    if (_type[0] == Type.rating)
                      _type[0] = Type.all;
                    else
                      _type[0] = Type.rating;
                  });
                },
                icon: _type[0] == Type.rating
                    ? Icon(Icons.chat_outlined)
                    : Icon(Icons.analytics_outlined),
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
                  _type[_indexBottomNavBar] == Type.rating
                      ? GraphList(_onRefresh)
                      : DiscussionList(
                          type: _type[_indexBottomNavBar],
                          from: User.admin,
                          to: User.faculty,
                          onRefresh: _onRefresh,
                        ),
                  DiscussionList(
                    type: _type[_indexBottomNavBar],
                    from: User.admin,
                    to: User.student,
                    onRefresh: _onRefresh,
                  ),
                ],
              ),
      ),
    );
  }
}
