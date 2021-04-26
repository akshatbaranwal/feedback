import '../../import.dart';

class FacultyDashboardStudent extends StatefulWidget {
  @override
  _FacultyDashboardStudentState createState() =>
      _FacultyDashboardStudentState();
}

class _FacultyDashboardStudentState extends State<FacultyDashboardStudent> {
  @override
  Widget build(BuildContext context) {
    var _items = Provider.of<FacultyStudentList>(context).items;

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
                from: User.faculty,
                to: User.student,
              ),
            );
          },
          child: DiscussionCard(
            item: _items[index],
            from: User.faculty,
            to: User.student,
          ),
        ),
      ),
    );
  }
}
