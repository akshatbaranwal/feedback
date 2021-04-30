import '../../import.dart';

class GraphList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var rating = Provider.of<FacultyStudentList>(context).ratings;

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
            physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics()),
            padding: const EdgeInsets.all(10),
            itemCount: rating.length,
            itemBuilder: (ctx, index) => Card(
              child: Column(
                children: [
                  SizedBox(height: 20),
                  Text(
                    rating[index].facultyname,
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    rating[index].coursename,
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
}
