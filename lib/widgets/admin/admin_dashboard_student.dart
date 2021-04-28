import '../../import.dart';

class AdminDashboardStudent extends StatelessWidget {
  final type;
  AdminDashboardStudent(this.type);
  @override
  Widget build(BuildContext context) {
    List<AdminStudent> items = Provider.of<AdminStudentList>(context).items;
    items = type == Type.all
        ? items
        : items
            .where((element) => element.type == type.toString().split('.').last)
            .toList();

    return items.length == 0
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
            itemCount: items.length,
            itemBuilder: (ctx, index) => Card(
              child: InkWell(
                borderRadius: BorderRadius.circular(10),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (_) => DiscussionDialog(
                      item: items[index],
                      from: User.admin,
                      to: User.student,
                    ),
                  );
                },
                child: DiscussionCard(
                  item: items[index],
                  from: User.admin,
                  to: User.student,
                ),
              ),
            ),
          );
  }
}
