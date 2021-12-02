import 'package:flutter/cupertino.dart';
import 'package:liftlogmobile/models/session.dart';
import 'package:liftlogmobile/models/workout.dart';
import 'package:liftlogmobile/services/api_service.dart';
import 'package:liftlogmobile/utils/styles.dart';

class WorkoutListItem extends StatefulWidget {
  Session _session;
  String _exerciseName;
  Workout _workout;
  Function _reloadWorkouts;

  WorkoutListItem(this._session, this._workout, this._exerciseName, this._reloadWorkouts);

  @override
  State<WorkoutListItem> createState() => _WorkoutListItemState();
}

class _WorkoutListItemState extends State<WorkoutListItem> {
  Widget _deleteWorkoutDialog(
      BuildContext context, Session session, Workout workout, Function _reloadWorkouts) {
    bool deleting = false;

    return CupertinoAlertDialog(
      title: const Text("Delete Workout"),
      content: const Text("Are you sure?"),
      actions: [
        CupertinoDialogAction(
          child: const Text("Cancel"),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        CupertinoDialogAction(
          child: Text("Delete",
              style: Styles.cautiousDialogAction(context, !deleting)),
          onPressed: () async {
            if (!deleting) {
              setState(() {
                deleting = true;
              });
              bool deleted = await APIService.deleteWorkout(widget._session, widget._workout);
              if (deleted) {
                _reloadWorkouts();
                Navigator.pop(context);
                Navigator.pop(context);
              }
              setState(() {
                deleting = false;
              });
            }
          },
        ),
      ],
    );
  }

  Widget _ellipsisOptions(context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10, top: 10, bottom: 10),
      child: GestureDetector(
        child: Icon(
          CupertinoIcons.ellipsis,
          color: Styles.ellipsisIcon(context),
        ),
        onTap: () async {
          await showCupertinoModalPopup(
            context: context,
            builder: (BuildContext buildContext) {
              return CupertinoActionSheet(
                actions: [
                  CupertinoActionSheetAction(
                    onPressed: () {
                      showCupertinoDialog(
                        context: context,
                        builder: (BuildContext buildContext) {
                          return _deleteWorkoutDialog(
                            buildContext,
                            widget._session,
                            widget._workout,
                            widget._reloadWorkouts,
                          );
                        },
                      );
                    },
                    child: const Text("Delete"),
                  ),
                ],
                cancelButton: CupertinoActionSheetAction(
                  child: const Text(
                    "Cancel",
                  ),
                  onPressed: () {
                    Navigator.of(buildContext).pop();
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15, left: 10, right: 10),
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
                  padding: const EdgeInsets.only(left: 15, top: 10, bottom: 10),
                  child: Text(
                    widget._workout.exerciseId.substring(0, 6) +
                        " :: " +
                        widget._exerciseName,
                    style: Styles.workoutListItemHeader(context),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15, bottom: 10),
                  child: Text(
                    "${widget._workout.sets} Set${widget._workout.sets==1?'':'s'}",
                    style: Styles.workoutListItemDetails(context),
                  ),
                ),
              ],
            ),
            _ellipsisOptions(context),
          ],
        ),
      ),
    );
  }
}
