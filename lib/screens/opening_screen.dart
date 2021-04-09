import 'package:feedback/import.dart';

class OpeningScreen extends StatelessWidget {
  static const routeName = '/';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 100),
            Text(
              'Feedback\nManagement\nSystem',
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.w300,
              ),
            ),
            SizedBox(height: 200),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushNamed(LoginScreen.routeName);
              },
              child: Text('Raise Your Voice'),
            ),
          ],
        ),
      ),
    );
  }
}
