import '../../import.dart';

class StudentDashboardAdmin extends StatefulWidget {
  final type;
  StudentDashboardAdmin(this.type);
  @override
  _StudentDashboardAdminState createState() => _StudentDashboardAdminState();
}

class _StudentDashboardAdminState extends State<StudentDashboardAdmin> {
  @override
  Widget build(BuildContext context) {
    var _items = Provider.of<AdminStudentList>(context).items;
    _items = widget.type == Type.all
        ? _items
        : _items
            .where((element) =>
                element.type == widget.type.toString().split('.').last)
            .toList();

    return _items.length == 0
        ? Stack(
            children: [
              ListView(),
              Center(
                child: Text(
                  'Nothing here!',
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ],
          )
        : ListView.builder(
            physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics()),
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
                      from: User.student,
                      to: User.admin,
                    ),
                  );
                },
                child: DiscussionCard(
                  item: _items[index],
                  from: User.student,
                  to: User.admin,
                ),
              ),
            ),
          );
  }
}
