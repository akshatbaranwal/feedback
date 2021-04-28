import '../../import.dart';

class FacultyDashboardAdmin extends StatefulWidget {
  final type;
  FacultyDashboardAdmin(this.type);
  @override
  _FacultyDashboardAdminState createState() => _FacultyDashboardAdminState();
}

class _FacultyDashboardAdminState extends State<FacultyDashboardAdmin> {
  @override
  Widget build(BuildContext context) {
    var _items = Provider.of<AdminFacultyList>(context).items;
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
                      from: User.faculty,
                      to: User.admin,
                    ),
                  );
                },
                child: DiscussionCard(
                  item: _items[index],
                  from: User.faculty,
                  to: User.admin,
                ),
              ),
            ),
          );
  }
}
