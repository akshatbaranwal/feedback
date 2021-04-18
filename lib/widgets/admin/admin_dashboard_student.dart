import 'package:intl/intl.dart';

import '../../import.dart';

class AdminDashboardStudent extends StatefulWidget {
  final type;
  AdminDashboardStudent(this.type);
  @override
  _AdminDashboardStudentState createState() => _AdminDashboardStudentState();
}

class _AdminDashboardStudentState extends State<AdminDashboardStudent> {
  AdminStudentList adminStudent;

  Future<void> _view() async {
    return showDialog(context: context, builder: (ctx) => AlertDialog());
  }

  @override
  Widget build(BuildContext context) {
    adminStudent = Provider.of<AdminStudentList>(context);
    var items = widget.type == Type.all
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
                            items[index].name,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            items[index].email,
                            style: TextStyle(
                              color: Colors.black38,
                              fontSize: 12,
                            ),
                          ),
                        ],
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
                      'Last Modified:   ${DateFormat.yMMMd().add_jm().format(items[index].modifiedAt)}',
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
