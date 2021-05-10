import '../import.dart';

class Loading extends StatefulWidget {
  static const routeName = '/';
  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> with TickerProviderStateMixin {
  AnimationController _controller;
  bool _isInit = true;
  Random _random = Random();
  String _msg;

  Future<void> _connect() async {
    await initConnection();
    await Future.wait([
      Provider.of<StudentData>(context, listen: false).fetchEmails(),
      Provider.of<FacultyData>(context, listen: false).fetchEmails(),
      Provider.of<AdminData>(context, listen: false).fetchEmails(),
    ]);
    Future.wait([
      Provider.of<StudentData>(context, listen: false).fetchBranches(),
      Provider.of<StudentData>(context, listen: false).fetchEnrolls(),
      Provider.of<FacultyData>(context, listen: false).fetchCourses(),
    ]);
    setState(() {
      _controller.value = 1;
    });
    await Navigator.of(context).pushNamed(LoginScreen.routeName);
    await connection.close();
    SystemNavigator.pop();
  }

  @override
  void initState() {
    _msg = funnyLoadingMessages[_random.nextInt(funnyLoadingMessages.length)];
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )
      ..addListener(() {
        setState(() {});
      })
      ..forward();
    super.initState();
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
          SizedBox(height: 30),
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
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 40,
              vertical: 20,
            ),
            child: Text(
              _msg,
              maxLines: 5,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
          SizedBox(
            height: 2,
            width: 150,
            child: LinearProgressIndicator(
              value: _controller.value,
            ),
          ),
          SizedBox(height: 50),
        ],
      ),
    );
  }
}
