import 'package:flutter/cupertino.dart';
import 'package:liftlogmobile/models/exercise.dart';
import 'package:liftlogmobile/models/session.dart';
import 'package:liftlogmobile/models/workout.dart';
import 'package:liftlogmobile/services/api_service.dart';
import 'package:liftlogmobile/utils/styles.dart';
import 'package:liftlogmobile/widgets/log/session_info_section.dart';
import 'package:liftlogmobile/widgets/overview/overview_workout_item.dart';
import 'package:liftlogmobile/widgets/shared/navigation_bar_text.dart';

class OverviewSessionScreen extends StatefulWidget {
  Map<String, Exercise> _exerciseMap;
  Session _session;

  OverviewSessionScreen(this._exerciseMap, this._session);

  @override
  State<OverviewSessionScreen> createState() => _OverviewSessionScreenState();
}

class _OverviewSessionScreenState extends State<OverviewSessionScreen> {
  bool _loading = false;
  late List<Workout> _workouts = [];

  @override
  void initState() {
    _loadWorkouts();
  }

  void _loadWorkouts() async {
    setState(() {
      _loading = true;
    });
    List<Workout> loadedWorkouts =
        await APIService.getWorkouts(widget._session);
    setState(() {
      _workouts = loadedWorkouts;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: Styles.defaultBackground(context),
      navigationBar: CupertinoNavigationBar(
        middle: navigationBarTitle(context, widget._session.name),
      ),
      child: SafeArea(
          top: true,
          child: ListView(
            children: [sessionInfoSection(context, widget._session)] +
                (_loading
                    ? [
                        const Padding(
                          padding: EdgeInsets.only(top: 15),
                          child: CupertinoActivityIndicator(),
                        )
                      ]
                    : _workouts.map((workout) {
                        Exercise? exercise =
                            widget._exerciseMap[workout.exerciseId];
                        String exerciseName = exercise != null
                            ? exercise.name
                            : "Unknown Exercise";
                        return OverviewWorkoutItem(exerciseName, workout);
                      }).toList()),
          )),
    );
  }
}
