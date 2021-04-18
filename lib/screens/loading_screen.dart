import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

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
    await Provider.of<StudentData>(context, listen: false).fetchEmails();
    await Provider.of<StudentData>(context, listen: false).fetchBranches();
    await Provider.of<FacultyData>(context, listen: false).fetchEmails();
    await Provider.of<FacultyData>(context, listen: false).fetchCourses();
    await Provider.of<AdminData>(context, listen: false).fetchEmails();
    await Navigator.of(context).pushReplacementNamed(LoginScreen.routeName);
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Feedback\nManagement\nSystem',
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.w300,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
