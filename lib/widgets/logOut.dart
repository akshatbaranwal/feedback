import '../import.dart';

void logOut(BuildContext context) {
  Provider.of<AdminData>(context, listen: false).logout();
  Provider.of<FacultyData>(context, listen: false).logout();
  Provider.of<StudentData>(context, listen: false).logout();
  Provider.of<AdminFacultyList>(context, listen: false).logout();
  Provider.of<AdminStudentList>(context, listen: false).logout();
  Provider.of<FacultyStudentList>(context, listen: false).logout();
  Navigator.of(context).popUntil(ModalRoute.withName(LoginScreen.routeName));
}
