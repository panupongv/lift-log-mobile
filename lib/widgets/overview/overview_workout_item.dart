import 'package:expandable/expandable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:liftlogmobile/models/workout.dart';
import 'package:liftlogmobile/utils/styles.dart';

class ExpandedSection extends StatelessWidget {
  final GlobalKey _widgetKey = GlobalKey();
  Workout _workout;

  ExpandedSection(this._workout);

  double height() {
    final RenderBox renderBox =
        _widgetKey.currentContext?.findRenderObject() as RenderBox;

    final Size size = renderBox.size;

    return size.height;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, bottom: 10),
      child: Text(
        _workout.content.split(Workout.setSeparator).join('\n'),
        style: Styles.historySetHeader(context),
      ),
    );
  }
}

class OverviewWorkoutItem extends StatefulWidget {
  final String _exerciseName;
  final Workout _workout;

  OverviewWorkoutItem(this._exerciseName, this._workout);

  @override
  State<OverviewWorkoutItem> createState() => _OverviewWorkoutItemState();
}

class _OverviewWorkoutItemState extends State<OverviewWorkoutItem>
    with SingleTickerProviderStateMixin {
  bool _expanded = false;
  late final AnimationController _controller = AnimationController(
    duration: const Duration(milliseconds: 1000),
    vsync: this,
  );
  late final Animation<double> _heightAnimation =
      Tween<double>(begin: 0, end: 1).animate(
    CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ),
  );

  @override
  void initState() {
    _controller.addListener(() {
      setState(() {});
    });
  }

  Widget _expandedSection() {
    ExpandedSection content = ExpandedSection(widget._workout);

    return Container(
      height: 100 * _heightAnimation.value,
      child: content,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        _expanded = !_expanded;
        if (_expanded) {
          _controller.forward();
        } else {
          await _controller.reverse();
          _controller.reset();
        }
      },
      child: Padding(
        padding: const EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 5),
        child: Container(
          decoration: BoxDecoration(
            color: Styles.listItemBackground(context),
            borderRadius: const BorderRadius.all(Radius.circular(8)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 15, top: 10, bottom: 10),
                    child: Text(
                      widget._exerciseName,
                      style: Styles.workoutListItemHeader(context),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15, bottom: 10),
                    child: Text(
                      "${widget._workout.sets} Set${widget._workout.sets == 1 ? '' : 's'}",
                      style: Styles.workoutListItemDetails(context),
                    ),
                  ),
                  _expandedSection()
                ],
              ),
              Icon(CupertinoIcons.chevron_down),
            ],
          ),
        ),
      ),
    );
  }
}
