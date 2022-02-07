import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:liftlogmobile/models/workout.dart';
import 'package:liftlogmobile/utils/styles.dart';

class ExpandedSection extends StatelessWidget {
  Workout _workout;

  double heightPerItem = 25;
  List<String> items = [];

  bool _expanded;

  ExpandedSection(this._workout, this._expanded) {
    items = _workout.content.split(Workout.setSeparator);
    if (items.length == 1 && items[0].length == 0) items = [];
  }

  double totalHeight() => heightPerItem * items.length + 10;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, bottom: 10),
      child: Column(
        children: items.map((item) {
          List<String> weightAndReps = item.split(Workout.weightRepsSeparator);

          return _expanded
              ? SizedBox(
                  height: heightPerItem,
                  child: Row(
                    children: [
                      Container(
                          alignment: Alignment.centerRight,
                          width: 60,
                          child: Text(
                            "${weightAndReps[0]} kg",
                            style: Styles.overviewWorkoutContent(context),
                          )),
                      Container(
                          alignment: Alignment.centerRight,
                          width: 80,
                          child: Text(
                            "${weightAndReps[1]} reps",
                            style: Styles.overviewWorkoutContent(context),
                          )),
                    ],
                  ),
                )
              : Container();
        }).toList(),
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
    duration: const Duration(milliseconds: 600),
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

  Widget _rotatingIcon(context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: Transform.rotate(
          angle: pi * _heightAnimation.value,
          child: Icon(CupertinoIcons.chevron_down)),
    );
  }

  Widget _expandedSection_() {
    ExpandedSection content = ExpandedSection(widget._workout, _expanded);

    return SizedBox(
      height: content.totalHeight() * _heightAnimation.value,
      child: content,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if (!_expanded) {
          await _controller.forward();
          setState(() {
            _expanded = !_expanded;
          });
        } else {
          setState(() {
            _expanded = !_expanded;
          });
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
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 15, top: 10, bottom: 10),
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
                    ],
                  ),
                  _rotatingIcon(context),
                ],
              ),
              _expandedSection_()
            ],
          ),
        ),
      ),
    );
  }
}
