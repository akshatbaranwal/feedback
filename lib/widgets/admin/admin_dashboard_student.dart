import '../../import.dart';

class AdminDashboardStudent extends StatefulWidget {
  final type;
  AdminDashboardStudent(this.type);
  @override
  _AdminDashboardStudentState createState() => _AdminDashboardStudentState();
}

class _AdminDashboardStudentState extends State<AdminDashboardStudent> {
  @override
  Widget build(BuildContext context) {
    var _items = Provider.of<AdminStudentList>(context).items;
    _items = widget.type == Type.all
        ? _items
        : _items
            .where((element) =>
                element.type == widget.type.toString().split('.').last)
            .toList();

    return ListView.builder(
      padding: const EdgeInsets.all(10),
      itemCount: _items.length,
      itemBuilder: (ctx, index) => Card(
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () {
            showDialog(
              context: context,
              builder: (_) => DiscussionDialog(
                item: _items[index],
                from: User.admin,
                to: User.student,
              ),
            );
          },
          child: DiscussionCard(
            item: _items[index],
            from: User.admin,
            to: User.student,
          ),
        ),
      ),
    );
  }
}
