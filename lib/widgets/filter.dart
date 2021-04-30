import '../import.dart';

class Filter extends StatelessWidget {
  final Type type;
  final Function callback;

  Filter({
    @required this.type,
    @required this.callback,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Filter'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.resolveWith((_) {
                if (type == Type.all)
                  return Theme.of(context).colorScheme.primary.withOpacity(0.1);
                else
                  return null;
              }),
            ),
            onPressed: callback(Type.all),
            child: Text(
              'All',
              style: TextStyle(fontSize: 17),
            ),
          ),
          TextButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.resolveWith((_) {
                if (type == Type.opinion)
                  return Theme.of(context).colorScheme.primary.withOpacity(0.1);
                else
                  return null;
              }),
            ),
            onPressed: callback(Type.opinion),
            child: Text(
              'Opinion',
              style: TextStyle(fontSize: 17),
            ),
          ),
          TextButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.resolveWith((_) {
                if (type == Type.request)
                  return Theme.of(context).colorScheme.primary.withOpacity(0.1);
                else
                  return null;
              }),
            ),
            onPressed: callback(Type.request),
            child: Text(
              'Request',
              style: TextStyle(fontSize: 17),
            ),
          ),
          TextButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.resolveWith((_) {
                if (type == Type.query)
                  return Theme.of(context).colorScheme.primary.withOpacity(0.1);
                else
                  return null;
              }),
            ),
            onPressed: callback(Type.query),
            child: Text(
              'Query',
              style: TextStyle(fontSize: 17),
            ),
          ),
        ],
      ),
    );
  }
}
