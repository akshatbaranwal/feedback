import '../../import.dart';

class ConfirmExit extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Confirm Exit ?'),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(
              child: TextButton(
                child: Text(
                  'No',
                  style: TextStyle(fontSize: 16),
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
                  style: TextStyle(fontSize: 16),
                ),
                onPressed: () {
                  Navigator.of(context)
                      .popUntil(ModalRoute.withName(Loading.routeName));
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
