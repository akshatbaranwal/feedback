import 'package:intl/intl.dart';

import '../../import.dart';

class FacultyDashboardStudent extends StatefulWidget {
  final type;
  FacultyDashboardStudent(this.type);
  @override
  _FacultyDashboardStudentState createState() =>
      _FacultyDashboardStudentState();
}

class _FacultyDashboardStudentState extends State<FacultyDashboardStudent> {
  FacultyStudentList facultyStudent;
  TextEditingController _replyController = TextEditingController();

  Future<void> _view(FacultyStudent item) async {
    return showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.studentname,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  item.studentemail,
                  style: TextStyle(
                    color: Colors.black38,
                    fontSize: 12,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  item.subject,
                  maxLines: 5,
                  style: TextStyle(
                    fontSize: 15,
                  ),
                ),
                SizedBox(height: 15),
                Text(
                  item.body,
                  maxLines: 50,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      '${DateFormat.yMMMd().add_jm().format(item.createdAt)}',
                      style: TextStyle(
                        color: Colors.black38,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Divider(),
                SizedBox(height: 10),
                if (item.reply == null) ...[
                  TextField(
                    controller: _replyController,
                    maxLines: 3,
                    keyboardType: TextInputType.multiline,
                    decoration: InputDecoration(
                      labelText: 'Reply',
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      facultyStudent.reply(
                        reply: _replyController.text,
                        id: item.id,
                      );
                      Navigator.of(ctx).pop();
                    },
                    icon: Icon(Icons.send),
                  ),
                ],
                if (item.reply != null) ...[
                  Text(
                    'Reply:',
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 13,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    item.reply,
                    maxLines: 50,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        '${DateFormat.yMMMd().add_jm().format(item.replyCreatedAt)}',
                        style: TextStyle(
                          color: Colors.black38,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
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
            _view(facultyStudent.items[index]);
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
                            facultyStudent.items[index].studentname,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            facultyStudent.items[index].studentemail,
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
                      '${DateFormat.yMMMd().add_jm().format(facultyStudent.items[index].createdAt)}',
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
