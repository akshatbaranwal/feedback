import 'package:intl/intl.dart';

import '../../import.dart';

class DiscussionDialog extends StatefulWidget {
  final item;
  final User from;
  final User to;

  DiscussionDialog({
    @required this.item,
    @required this.from,
    @required this.to,
  });
  @override
  _DiscussionDialogState createState() => _DiscussionDialogState();
}

class _DiscussionDialogState extends State<DiscussionDialog> {
  AdminFacultyList _adminFaculty;
  AdminStudentList _adminStudent;
  FacultyStudentList _facultyStudent;
  TextEditingController _replyController = TextEditingController();

  @override
  void dispose() {
    _replyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _adminFaculty = Provider.of<AdminFacultyList>(context);
    _adminStudent = Provider.of<AdminStudentList>(context);
    _facultyStudent = Provider.of<FacultyStudentList>(context);

    return Dialog(
      insetPadding: const EdgeInsets.all(20),
      child: ListView(
        padding: const EdgeInsets.all(20),
        shrinkWrap: true,
        children: [
          Center(
            child: Text(
              widget.to == User.admin
                  ? 'Admin'
                  : widget.to == User.faculty
                      ? widget.item.facultyname
                      : widget.item.studentname,
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          if (widget.to != User.admin) ...[
            SizedBox(height: 2),
            Center(
              child: Text(
                widget.to == User.faculty
                    ? widget.item.facultyemail
                    : widget.item.studentemail,
                style: TextStyle(
                  color: Colors.black38,
                  fontSize: 12,
                ),
              ),
            ),
          ],
          SizedBox(height: 20),
          Text(
            widget.item.subject,
            maxLines: 5,
            style: TextStyle(
              fontSize: 15,
            ),
          ),
          SizedBox(height: 15),
          Text(
            widget.item.body,
            maxLines: 50,
            style: TextStyle(
              fontSize: 14,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment:
                widget.to == User.admin || widget.from == User.admin
                    ? MainAxisAlignment.spaceBetween
                    : MainAxisAlignment.end,
            children: [
              if (widget.to == User.admin || widget.from == User.admin)
                Text(
                  widget.item.type,
                  style: TextStyle(
                    color: Colors.black38,
                    fontSize: 12,
                  ),
                ),
              Text(
                '${DateFormat.yMMMd().add_jm().format(widget.item.createdAt)}',
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
          if (widget.item.reply == null)
            if (widget.from == User.admin ||
                widget.from == User.faculty && widget.to == User.student)
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _replyController,
                      maxLines: 3,
                      keyboardType: TextInputType.multiline,
                      decoration: InputDecoration(
                        labelText: 'Reply',
                      ),
                    ),
                  ),
                  IconButton(
                    padding: const EdgeInsets.all(0),
                    alignment: Alignment.centerRight,
                    onPressed: () async {
                      if (_replyController.text.trim() != '' &&
                          _replyController.text != null) {
                        try {
                          if (widget.from == User.faculty)
                            await _facultyStudent.reply(
                              reply: _replyController.text,
                              id: widget.item.id,
                            );
                          else if (widget.to == User.faculty)
                            await _adminFaculty.reply(
                              reply: _replyController.text,
                              id: widget.item.id,
                            );
                          else
                            await _adminStudent.reply(
                              reply: _replyController.text,
                              id: widget.item.id,
                            );
                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('reply added!'),
                            duration: Duration(seconds: 2),
                          ));
                        } catch (error) {
                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Connection Error'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        }
                      }
                    },
                    icon: Icon(Icons.send),
                    color: Colors.blueGrey,
                  ),
                ],
              )
            else
              Text(
                'no replies yet',
                style: TextStyle(
                  color: Colors.black54,
                  fontStyle: FontStyle.italic,
                ),
              ),
          if (widget.item.reply != null) ...[
            Text(
              'Reply:',
              style: TextStyle(
                color: Colors.black54,
                fontSize: 13,
              ),
            ),
            SizedBox(height: 10),
            Text(
              widget.item.reply,
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
                  '${DateFormat.yMMMd().add_jm().format(widget.item.replyCreatedAt)}',
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
    );
  }
}
