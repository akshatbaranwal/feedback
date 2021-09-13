import '../../import.dart';

class ConfirmDelete extends StatelessWidget {
  final Function del;
  ConfirmDelete(this.del);
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Confirm Delete ?'),
      content: Text('All your data will be deleted.'),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(
              child: TextButton(
                child: Text(
                  'No',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.green,
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
            Expanded(
              child: TextButton(
                child: Text(
                  'Yes',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.red,
                  ),
                ),
                onPressed: () {
                  del();
                  logOut(context);
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
