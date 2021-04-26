import '../../import.dart';

class AdminDashboardFaculty extends StatefulWidget {
  final type;
  AdminDashboardFaculty(this.type);
  @override
  _AdminDashboardFacultyState createState() => _AdminDashboardFacultyState();
}

class _AdminDashboardFacultyState extends State<AdminDashboardFaculty> {
  List<FacultyRating> _rating = [];
  List<AdminFaculty> _items = [];

  Widget _discussionBuilder() {
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
                to: User.faculty,
              ),
            );
          },
          child: DiscussionCard(
            item: _items[index],
            from: User.admin,
            to: User.faculty,
          ),
        ),
      ),
    );
  }

  Widget _ratingBuilder() {
    return ListView.builder(
      padding: const EdgeInsets.all(10),
      itemCount: _rating.length,
      itemBuilder: (ctx, index) => Card(
        child: Column(
          children: [
            SizedBox(height: 20),
            Text(
              _rating[index].name,
              style: TextStyle(
                fontSize: 15,
              ),
            ),
            SizedBox(height: 5),
            Text(
              _rating[index].course,
              style: TextStyle(
                fontSize: 13,
                color: Colors.black87,
              ),
            ),
            Graph(_rating[index]),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _items = Provider.of<AdminFacultyList>(context).items;
    _rating = Provider.of<FacultyStudentList>(context).ratings;
    _items = widget.type == Type.all
        ? _items
        : _items
            .where((element) =>
                element.type == widget.type.toString().split('.').last)
            .toList();

    return widget.type == Type.rating ? _ratingBuilder() : _discussionBuilder();
  }
}
