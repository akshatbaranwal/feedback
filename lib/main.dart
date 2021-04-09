import 'package:feedback/import.dart';
import 'package:postgres/postgres.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final connection = PostgreSQLConnection(
    'localhost',
    5432,
    'Feedback',
    username: 'postgres',
    password: 'a',
  ).open();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Feedback Management',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        accentColor: Colors.lightBlueAccent,
        backgroundColor: Colors.grey,
        // appBarTheme: AppBarTheme(),
      ),
      initialRoute: '/',
      routes: {
        '/': (ctx) => OpeningScreen(),
        LoginScreen.routeName: (ctx) => LoginScreen(connection),
      },
    );
  }
}
