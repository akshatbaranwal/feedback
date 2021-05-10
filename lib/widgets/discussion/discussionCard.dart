import 'package:intl/intl.dart';
import '../../import.dart';

class DiscussionCard extends StatelessWidget {
  final item;
  final User from;
  final User to;

  DiscussionCard({
    @required this.item,
    @required this.from,
    @required this.to,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 155,
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                to == User.admin
                    ? Text(
                        'Admin',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            to == User.faculty
                                ? item.facultyname
                                : item.studentname,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            to == User.faculty
                                ? item.facultyemail
                                : item.studentemail,
                            style: TextStyle(
                              color: Colors.black38,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                SizedBox(height: 15),
                Text(
                  item.subject,
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  item.body,
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
            mainAxisAlignment: to == User.admin || from == User.admin
                ? MainAxisAlignment.spaceBetween
                : MainAxisAlignment.end,
            children: [
              if (to == User.admin || from == User.admin)
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
          )
        ],
      ),
    );
  }
}
