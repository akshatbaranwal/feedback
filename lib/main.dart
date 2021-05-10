import './import.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => AdminData()),
        ChangeNotifierProvider(create: (ctx) => FacultyData()),
        ChangeNotifierProvider(create: (ctx) => StudentData()),
        ChangeNotifierProvider(create: (ctx) => AdminStudentList()),
        ChangeNotifierProvider(create: (ctx) => AdminFacultyList()),
        ChangeNotifierProvider(create: (ctx) => FacultyStudentList()),
      ],
      child: MaterialApp(
        title: 'Feedback Management',
        theme: ThemeData(
          primarySwatch: Colors.blueGrey,
          dialogTheme: DialogTheme(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
          ),
          cardTheme: CardTheme(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            margin: const EdgeInsets.all(8),
            elevation: 3,
          ),
          sliderTheme: SliderTheme.of(context).copyWith(
            trackShape: RectangularSliderTrackShape(),
          ),
        ),
        initialRoute: '/',
        routes: {
          AddNew.routeName: (ctx) => AddNew(),
          Loading.routeName: (ctx) => Loading(),
          LoginScreen.routeName: (ctx) => LoginScreen(),
          UpdateAccount.routeName: (ctx) => UpdateAccount(),
          AdminDashboard.routeName: (ctx) => AdminDashboard(),
          FacultyDashboard.routeName: (ctx) => FacultyDashboard(),
          StudentDashboard.routeName: (ctx) => StudentDashboard(),
        },
      ),
    );
  }
}
