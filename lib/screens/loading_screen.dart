import '../import.dart';

class Loading extends StatefulWidget {
  static const routeName = '/';
  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  double _progress;
  bool _isInit = true, _noInternet = true;
  Random _random = Random();
  String _msg = "Waiting for internet connection...";

  Future<void> _connect() async {
    while (_noInternet) {
      _noInternet = false;
      try {
        await initConnection();
      } catch (error) {
        _noInternet = true;
        await Future.delayed(Duration(seconds: 1));
      }
    }
    setState(() {
      _progress = 0;
      _msg = funnyLoadingMessages[_random.nextInt(funnyLoadingMessages.length)];
    });
    await Future.wait([
      Provider.of<StudentData>(context, listen: false)
          .fetchEmails()
          .then((value) {
        setState(() {
          _progress += 0.15;
        });
      }),
      Provider.of<FacultyData>(context, listen: false)
          .fetchEmails()
          .then((value) {
        setState(() {
          _progress += 0.15;
        });
      }),
      Provider.of<AdminData>(context, listen: false)
          .fetchEmails()
          .then((value) {
        setState(() {
          _progress += 0.15;
        });
      }),
      Provider.of<StudentData>(context, listen: false)
          .fetchBranches()
          .then((value) {
        setState(() {
          _progress += 0.15;
        });
      }),
      Provider.of<StudentData>(context, listen: false)
          .fetchEnrolls()
          .then((value) {
        setState(() {
          _progress += 0.15;
        });
      }),
      Provider.of<FacultyData>(context, listen: false)
          .fetchCourses()
          .then((value) {
        setState(() {
          _progress += 0.15;
        });
      }),
    ]);
    setState(() {
      _progress = 1;
    });
    await Navigator.of(context).pushNamed(LoginScreen.routeName);
    await connection.close();
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
              value: _progress,
            ),
          ),
          SizedBox(height: 50),
        ],
      ),
    );
  }
}
