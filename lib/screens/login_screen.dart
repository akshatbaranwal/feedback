import 'package:feedback/import.dart';

class LoginScreen extends StatefulWidget {
  final connection;
  LoginScreen(this.connection);
  static const routeName = '/login_screen';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  dynamic _data;

  Future<void> _getData() async {
    final db = Data(widget.connection);
    var results = await db.student('iit2019010@iiita.ac.in');
    setState(() {
      _data = results;
    });
    print(_data);
    await widget.connection.close();
  }

  @override
  void initState() {
    _getData();
    super.initState();
  }

  // bool _validEmail() {}

  // bool _validPassword() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Log In'),
      ),
      body: Container(
        height: 600,
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              maxLines: 1,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                hintText: 'Enter your college ID',
                labelText: 'Email',
                prefixIcon: Icon(Icons.email_outlined),
                border: OutlineInputBorder(),
                disabledBorder: null,
                enabledBorder: null,
                errorBorder: null,
                helperText: null,
                errorText: null,
              ),
              controller: _emailController,
              // onSubmitted: () {},
            ),
            TextField(
              maxLines: 1,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                hintText: 'Enter password',
                labelText: 'Password',
                prefixIcon: Icon(Icons.security_outlined),
                suffixIcon: Icon(Icons.remove_red_eye),
                border: OutlineInputBorder(),
                disabledBorder: null,
                enabledBorder: null,
                errorBorder: null,
                helperText: null,
              ),
              controller: _passwordController,
              // onSubmitted: () {},
            ),
          ],
        ),
      ),
    );
  }
}
