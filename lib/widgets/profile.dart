import '../import.dart';

class Profile extends StatelessWidget {
  final User from;
  Profile(this.from);

  @override
  Widget build(BuildContext context) {
    var del = from == User.admin
        ? Provider.of<AdminData>(context, listen: false).delete
        : from == User.faculty
            ? Provider.of<FacultyData>(context, listen: false).delete
            : Provider.of<StudentData>(context, listen: false).delete;

    return AlertDialog(
      title: Text('Account'),
      content: Container(
        height: from == User.admin ? 150 : 200,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (from != User.admin)
              Expanded(
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context)
                        .popAndPushNamed(UpdateAccount.routeName, arguments: {
                      'user': from,
                      'password': false,
                    });
                  },
                  child: Text(
                    'Update Details',
                    style: TextStyle(fontSize: 17),
                  ),
                ),
              ),
            Expanded(
              child: TextButton(
                onPressed: () {
                  Navigator.of(context)
                      .popAndPushNamed(UpdateAccount.routeName, arguments: {
                    'user': from,
                    'password': true,
                  });
                },
                child: Text(
                  'Change Password',
                  style: TextStyle(fontSize: 17),
                ),
              ),
            ),
            Expanded(
              child: TextButton(
                onPressed: () {
                  logOut(context);
                },
                child: Text(
                  'Log out',
                  style: TextStyle(fontSize: 17),
                ),
              ),
            ),
            Expanded(
              child: TextButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (_) => ConfirmDelete(del),
                  );
                },
                child: Text(
                  'Delete Account',
                  style: TextStyle(
                    fontSize: 17,
                    color: Colors.red,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
