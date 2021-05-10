import '../import.dart';

void logOut(BuildContext context) {
  Provider.of<AdminData>(context, listen: false).logout();
  Provider.of<FacultyData>(context, listen: false).logout();
  Provider.of<StudentData>(context, listen: false).logout();
  Provider.of<AdminFacultyList>(context, listen: false).logout();
  Provider.of<AdminStudentList>(context, listen: false).logout();
  Provider.of<FacultyStudentList>(context, listen: false).logout();
  Future.wait([
    Provider.of<StudentData>(context, listen: false).fetchEmails(),
    Provider.of<StudentData>(context, listen: false).fetchBranches(),
    Provider.of<StudentData>(context, listen: false).fetchEnrolls(),
    Provider.of<FacultyData>(context, listen: false).fetchEmails(),
    Provider.of<FacultyData>(context, listen: false).fetchCourses(),
    Provider.of<AdminData>(context, listen: false).fetchEmails(),
  ]);
  Navigator.of(context).popUntil(ModalRoute.withName(LoginScreen.routeName));
}
