import 'package:intl/intl.dart';

import '../../import.dart';

class StudentDashboardFaculty extends StatefulWidget {
  final type;
  StudentDashboardFaculty(this.type);
  @override
  _StudentDashboardFacultyState createState() =>
      _StudentDashboardFacultyState();
}

class _StudentDashboardFacultyState extends State<StudentDashboardFaculty> {
  FacultyStudentList facultyStudent;

  Future<void> _view() async {
    return showDialog(context: context, builder: (ctx) => AlertDialog());
  }

  @override
  Widget build(BuildContext context) {
    facultyStudent = Provider.of<FacultyStudentList>(context);

    return ListView.builder(
      padding: const EdgeInsets.all(10),
      itemCount: facultyStudent.items.length,
      itemBuilder: (ctx, index) => Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(8),
        elevation: 3,
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () async {
            _view();
          },
          child: Container(
            height: 155,
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            facultyStudent.items[index].facultyname,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            facultyStudent.items[index].facultyemail,
                            style: TextStyle(
                              color: Colors.black38,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 15),
                      Text(
                        facultyStudent.items[index].subject,
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        facultyStudent.items[index].body,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'Last Modified:   ${DateFormat.yMMMd().add_jm().format(facultyStudent.items[index].modifiedAt)}',
                      style: TextStyle(
                        color: Colors.black38,
                        fontSize: 12,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
