import '../../import.dart';

class DiscussionList extends StatelessWidget {
  final type;
  final from;
  final to;
  DiscussionList({
    this.type,
    @required this.from,
    @required this.to,
  });

  @override
  Widget build(BuildContext context) {
    List<dynamic> items;

    if (from != User.admin && to != User.admin)
      items = Provider.of<FacultyStudentList>(context).items;

    if (from != User.faculty && to != User.faculty)
      items = Provider.of<AdminStudentList>(context).items;

    if (from != User.student && to != User.student)
      items = Provider.of<AdminFacultyList>(context).items;

    if (type != null)
      items = type == Type.all
          ? items
          : items
              .where(
                  (element) => element.type == type.toString().split('.').last)
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
                      from: from,
                      to: to,
                    ),
                  );
                },
                child: DiscussionCard(
                  item: items[index],
                  from: from,
                  to: to,
                ),
              ),
            ),
          );
  }
}
