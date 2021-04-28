import '../import.dart';

class Loading extends StatefulWidget {
  static const routeName = '/';
  final connection;
  Loading(this.connection);
  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  var _isInit = true;

  Future<void> _connect() async {
    await widget.connection.open();
    await Future.wait([
      Provider.of<StudentData>(context, listen: false).fetchEmails(),
      Provider.of<StudentData>(context, listen: false).fetchBranches(),
      Provider.of<FacultyData>(context, listen: false).fetchEmails(),
      Provider.of<FacultyData>(context, listen: false).fetchCourses(),
      Provider.of<AdminData>(context, listen: false).fetchEmails(),
    ]);
    await Navigator.of(context).pushNamed(LoginScreen.routeName);
    await widget.connection.close();
    SystemNavigator.pop();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      _connect();
      _isInit = false;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 70),
          Expanded(
            child: Center(
              child: Text(
                'Feedback\nManagement\nSystem',
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
          ),
          Text(
            'Initializing...',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w300,
            ),
          ),
          SizedBox(height: 15),
          SizedBox(
            height: 2,
            width: 150,
            child: LinearProgressIndicator(),
          ),
          SizedBox(height: 80),
        ],
      ),
    );
  }
}
