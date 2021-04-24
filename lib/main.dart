import 'package:postgres/postgres.dart';

import 'import.dart';

void main() {
  runApp(MyApp());
}

final connection = PostgreSQLConnection(
  'ec2-3-234-85-177.compute-1.amazonaws.com',
  5432,
  'd228faaghhgu4',
  username: 'lqkqmhyttllxgb',
  password: 'f8057d66531c5d47201e4453f33e7346b473bfed1e3ebf1049a1c1fb616c8853',
  useSSL: true,
);

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => StudentData(connection)),
        ChangeNotifierProvider(create: (ctx) => FacultyData(connection)),
        ChangeNotifierProvider(create: (ctx) => AdminData(connection)),
        ChangeNotifierProvider(create: (ctx) => AdminStudentList(connection)),
        ChangeNotifierProvider(create: (ctx) => AdminFacultyList(connection)),
        ChangeNotifierProvider(create: (ctx) => FacultyStudentList(connection)),
        ChangeNotifierProvider(create: (ctx) => BranchCourse(connection)),
      ],
      child: MaterialApp(
        title: 'Feedback Management',
        theme: ThemeData(
          sliderTheme: SliderTheme.of(context).copyWith(
            trackShape: RectangularSliderTrackShape(),
          ),
          primarySwatch: Colors.blueGrey,
          // accentColor: Colors.white30,
          // backgroundColor: Colors.grey,
          // appBarTheme: AppBarTheme(),
        ),
        initialRoute: '/',
        routes: {
          AddNew.routeName: (ctx) => AddNew(),
          Loading.routeName: (ctx) => Loading(connection),
          LoginScreen.routeName: (ctx) => LoginScreen(),
          AdminDashboard.routeName: (ctx) => AdminDashboard(),
          FacultyDashboard.routeName: (ctx) => FacultyDashboard(),
          StudentDashboard.routeName: (ctx) => StudentDashboard(),
        },
      ),
    );
  }
}
