import 'package:flutter/cupertino.dart';
import 'package:liftlogmobile/models/exercise.dart';
import 'package:liftlogmobile/models/session.dart';
import 'package:liftlogmobile/models/workout.dart';
import 'package:liftlogmobile/services/api_service.dart';
import 'package:liftlogmobile/utils/styles.dart';
import 'package:liftlogmobile/widgets/log/workout_screen.dart';

class WorkoutListItem extends StatefulWidget {
  final Session _session;
  final Workout _workout;
  final Map<String, Exercise> _exerciseMap;
  final Function _reloadWorkouts;

  WorkoutListItem(
      this._session, this._workout, this._exerciseMap, this._reloadWorkouts);

  @override
  State<WorkoutListItem> createState() => _WorkoutListItemState();
}

class _WorkoutListItemState extends State<WorkoutListItem> {
  String _getExerciseName() {
    String exerciseId = widget._workout.exerciseId;
    if (exerciseId == Workout.defaultIdReference) {
      return "";
    }
    Exercise? exercise = widget._exerciseMap[exerciseId];
    if (exercise != null) return exercise.name;
    return "";
  }

  Widget _deleteButton(context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10, top: 10, bottom: 10),
      child: GestureDetector(
        child: Icon(
          CupertinoIcons.delete,
          color: Styles.ellipsisIcon(context),
        ),
        onTap: () async {
          bool deleting = false;

          showCupertinoDialog(
            context: context,
            builder: (context) => CupertinoAlertDialog(
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
                      bool deleted = await APIService.deleteWorkout(
                          widget._session, widget._workout);
                      if (deleted) {
                        widget._reloadWorkouts();
                        Navigator.pop(context);
                      }
                      setState(() {
                        deleting = false;
                      });
                    }
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        CupertinoPageRoute workoutPageRoute = CupertinoPageRoute(
            builder: (buildContext) => WorkoutScreen(
                widget._session, widget._workout, widget._exerciseMap));
        await Navigator.push(context, workoutPageRoute);
        widget._reloadWorkouts();
      },
      child: Padding(
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
                    padding:
                        const EdgeInsets.only(left: 15, top: 10, bottom: 10),
                    child: Text(
                      _getExerciseName(),
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
              _deleteButton(context),
            ],
          ),
        ),
      ),
    );
  }
}
