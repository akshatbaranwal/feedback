import '../../import.dart';

class AdminDashboardFaculty extends StatelessWidget {
  final type;
  AdminDashboardFaculty(this.type);

  Widget _discussionBuilder(BuildContext context, List<AdminFaculty> items) {
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
            physics: BouncingScrollPhysics(),
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
                      to: User.faculty,
                    ),
                  );
                },
                child: DiscussionCard(
                  item: items[index],
                  from: User.admin,
                  to: User.faculty,
                ),
              ),
            ),
          );
  }

  Widget ratingBuilder(List<FacultyRating> rating) {
    return rating.length == 0
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
            padding: const EdgeInsets.all(10),
            itemCount: rating.length,
            itemBuilder: (ctx, index) => Card(
              child: Column(
                children: [
                  SizedBox(height: 20),
                  Text(
                    rating[index].name,
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    rating[index].course,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.black87,
                    ),
                  ),
                  Graph(rating[index]),
                ],
              ),
            ),
          );
  }

  @override
  Widget build(BuildContext context) {
    List<FacultyRating> rating =
        Provider.of<FacultyStudentList>(context).ratings;
    List<AdminFaculty> items = Provider.of<AdminFacultyList>(context).items;

    items = type == Type.all
        ? items
        : items
            .where((element) => element.type == type.toString().split('.').last)
            .toList();

    return type == Type.rating
        ? ratingBuilder(rating)
        : _discussionBuilder(context, items);
  }
}
