import '../../import.dart';

class DiscussionList extends StatefulWidget {
  final type;
  final from;
  final to;
  final onRefresh;
  DiscussionList({
    this.type,
    this.onRefresh,
    @required this.from,
    @required this.to,
  });

  @override
  _DiscussionListState createState() => _DiscussionListState();
}

class _DiscussionListState extends State<DiscussionList>
    with AutomaticKeepAliveClientMixin {
  Map<User, ScrollController> _controller = {
    User.admin: ScrollController(),
    User.faculty: ScrollController(),
    User.student: ScrollController(),
  };

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    List<dynamic> items;

    if (widget.from != User.admin && widget.to != User.admin)
      items = Provider.of<FacultyStudentList>(context).items;

    if (widget.from != User.faculty && widget.to != User.faculty)
      items = Provider.of<AdminStudentList>(context).items;

    if (widget.from != User.student && widget.to != User.student)
      items = Provider.of<AdminFacultyList>(context).items;

    if (widget.type != null)
      items = widget.type == Type.all
          ? items
          : items
              .where((element) =>
                  element.type == widget.type.toString().split('.').last)
              .toList();

    return RefreshIndicator(
      onRefresh: widget.onRefresh,
      child: items.length == 0
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
          : DraggableScrollbar.semicircle(
              controller: _controller[widget.to],
              child: ListView.builder(
                controller: _controller[widget.to],
                physics: const AlwaysScrollableScrollPhysics(),
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
                          from: widget.from,
                          to: widget.to,
                        ),
                      );
                    },
                    child: DiscussionCard(
                      item: items[index],
                      from: widget.from,
                      to: widget.to,
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
