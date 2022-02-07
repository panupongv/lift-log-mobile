import 'package:flutter/cupertino.dart';
import 'package:liftlogmobile/models/exercise.dart';
import 'package:liftlogmobile/models/session.dart';
import 'package:liftlogmobile/models/workout.dart';
import 'package:liftlogmobile/services/api_service.dart';
import 'package:liftlogmobile/utils/styles.dart';
import 'package:liftlogmobile/widgets/log/session_info_section.dart';
import 'package:liftlogmobile/widgets/log/workout_list_item.dart';
import 'package:liftlogmobile/widgets/shared/navigation_bar_text.dart';

class SessionScreen extends StatefulWidget {
  final Map<String, Exercise> _exerciseMap;
  final Session _session;

  SessionScreen(this._session, this._exerciseMap);

  @override
  State<SessionScreen> createState() => _SessionScreenState();
}

class _SessionScreenState extends State<SessionScreen> {
  List<Workout> _workouts = [];
  bool _addingWorkout = false;
  bool _loadingInitialList = true;

  @override
  void initState() {
    _loadWorkouts();
  }

  void _loadWorkouts() async {
    List<Workout> loadedWorkouts =
        await APIService.getWorkouts(widget._session);
    if (mounted) {
      setState(() {
        _workouts = loadedWorkouts;
        _loadingInitialList = false;
      });
    }
  }

  Widget _newWorkoutButton() {
    return GestureDetector(
      child: Icon(
        CupertinoIcons.add_circled,
        color: _addingWorkout
            ? Styles.inactiveColor(context)
            : Styles.activeColor(context),
      ),
      onTap: () async {
        if (_addingWorkout) return;

        setState(() {
          _addingWorkout = true;
        });
        Workout newWorkout = Workout.blankWorkout();
        bool created =
            await APIService.createWorkout(widget._session, newWorkout);
        if (created) {
          _loadWorkouts();
        }
        setState(() {
          _addingWorkout = false;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: Styles.defaultBackground(context),
      navigationBar: CupertinoNavigationBar(
        middle: navigationBarTitle(context, widget._session.name),
        trailing: _newWorkoutButton(),
      ),
      child: SafeArea(
        top: true,
        child: Column(
          children: [
                sessionInfoSection(context, widget._session),
              ] +
              [
                Expanded(
                  child: ListView(
                    children: _loadingInitialList
                        ? [
                            const Padding(
                              padding: EdgeInsets.only(top: 15),
                              child: CupertinoActivityIndicator(),
                            )
                          ]
                        : _workouts.map((Workout wo) {
                            return WorkoutListItem(widget._session, wo,
                                widget._exerciseMap, _loadWorkouts);
                          }).toList(),
                  ),
                )
              ],
        ),
      ),
    );
  }
}
