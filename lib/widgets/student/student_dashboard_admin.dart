import 'package:intl/intl.dart';

import '../../import.dart';

class StudentDashboardAdmin extends StatefulWidget {
  final type;
  StudentDashboardAdmin(this.type);
  @override
  _StudentDashboardAdminState createState() => _StudentDashboardAdminState();
}

class _StudentDashboardAdminState extends State<StudentDashboardAdmin> {
  AdminStudentList adminStudent;
  List<AdminStudent> items;

  Future<void> _view(AdminStudent item) async {
    return showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Admin',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    item.type,
                    style: TextStyle(
                      color: Colors.black38,
                      fontSize: 12,
                    ),
                  ),
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
              if (item.reply == null)
                Text(
                  'no replies yet',
                  style: TextStyle(
                    color: Colors.black54,
                    fontStyle: FontStyle.italic,
                  ),
                )
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    adminStudent = Provider.of<AdminStudentList>(context);
    items = widget.type == Type.all
        ? adminStudent.items
        : adminStudent.items
            .where((element) =>
                element.type == widget.type.toString().split('.').last)
            .toList();

    return ListView.builder(
      padding: const EdgeInsets.all(10),
      itemCount: items.length,
      itemBuilder: (ctx, index) => Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(8),
        elevation: 3,
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () {
            setState(() {
              _view(items[index]);
            });
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
                      Text(
                        'Admin',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 15),
                      Text(
                        items[index].subject,
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        items[index].body,
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      items[index].type,
                      style: TextStyle(
                        color: Colors.black38,
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      '${DateFormat.yMMMd().add_jm().format(items[index].createdAt)}',
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
