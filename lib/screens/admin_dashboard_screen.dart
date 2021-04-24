import 'package:feedback/import.dart';

class AdminDashboard extends StatefulWidget {
  static const routeName = '/admin-dashboard';
  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  bool _isInit = true;
  Type _type = Type.all;
  int _indexBottomNavBar = 0;

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
            ],
          ),
        );
      },
    );
  }

  Future<void> _updateProfile() async {}

  @override
  void didChangeDependencies() {
    if (_isInit) {
      Provider.of<AdminFacultyList>(context).fetch();
      Provider.of<AdminStudentList>(context).fetch();
      _isInit = false;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          fontSize: 15,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: _indexBottomNavBar == 0
          ? AdminDashboardFaculty(_type)
          : AdminDashboardStudent(_type),
    );
  }
}
