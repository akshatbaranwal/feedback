import 'package:feedback/import.dart';

class Branch {
  final int branchid;
  final String branchname;

  Branch({
    @required this.branchid,
    @required this.branchname,
  });
}

class Course {
  final int courseid;
  final String coursename;

  Course({
    @required this.courseid,
    @required this.coursename,
  });
}

class BranchCourse with ChangeNotifier {
  final connection;
  BranchCourse(this.connection);

  List<Branch> _branchList = [];
  List<Course> _courseList = [];

  List<Branch> get branchList {
    return [..._branchList];
  }

  List<Course> get courseList {
    return [..._courseList];
  }

  Future<void> fetch() async {
    try {
      final response = await connection.query('''
      select *
      from branch, course
      ''');
      if (response.isNotEmpty) {
        final List<Branch> loadedBranches = [];
        final List<Course> loadedCourses = [];
        response.forEach((element) {
          loadedBranches.add(Branch(
            branchid: element[0],
            branchname: element[1],
          ));
          loadedCourses.add(Course(
            courseid: element[2],
            coursename: element[3],
          ));
        });
        _branchList = loadedBranches;
        _courseList = loadedCourses;
      }
    } catch (error) {
      throw (error);
    }
  }
}
