import '../../import.dart';

class GraphList extends StatelessWidget {
  final onRefresh;
  GraphList(this.onRefresh);

  @override
  Widget build(BuildContext context) {
    ScrollController _controller = ScrollController();
    var rating = Provider.of<FacultyStudentList>(context).ratings;

    return RefreshIndicator(
      onRefresh: onRefresh,
      child: rating.length == 0
          ? Stack(
              children: [
                ListView(),
                Center(
                  child: Text(
                    'No feedbacks yet :/',
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ],
            )
          : DraggableScrollbar.semicircle(
              controller: _controller,
              child: ListView.builder(
                controller: _controller,
                physics: const AlwaysScrollableScrollPhysics(),
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
              ),
            ),
    );
  }
}
