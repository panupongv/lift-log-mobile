import 'package:flutter/cupertino.dart';
import 'package:liftlogmobile/models/exercise.dart';
import 'package:liftlogmobile/models/session.dart';
import 'package:liftlogmobile/models/workout.dart';
import 'package:liftlogmobile/services/api_service.dart';
import 'package:liftlogmobile/utils/styles.dart';
import 'package:liftlogmobile/utils/text_utils.dart';
import 'package:liftlogmobile/widgets/log/workout_list_item.dart';
import 'package:liftlogmobile/widgets/log/workout_screen.dart';
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
    setState(() {
      _workouts = loadedWorkouts;
      _loadingInitialList = false;
    });
  }

  Widget _infoSection(context) {
    return Container(
      color: Styles.sessionInfoBackground(context),
      height: 100,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 5),
                child: Icon(
                  CupertinoIcons.calendar,
                  color: Styles.iconGrey(context),
                  size: 32,
                ),
              ),
              Text(
                "${widget._session.getDateInDisplayFormat()} (${widget._session.getDayOfWeek()})",
                style: Styles.sessionPageInfo(context),
              ),
            ],
          ),
          Container(
            height: 10,
          ),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 5),
                child: Icon(
                  CupertinoIcons.location,
                  color: Styles.iconGrey(context),
                  size: 32,
                ),
              ),
              Text(
                TextUtils.trimOverflow(widget._session.location, 30),
                style: Styles.sessionPageInfo(context),
              ),
            ],
          ),
        ],
      ),
    );
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
      navigationBar: CupertinoNavigationBar(
        middle: navigationBarTitle(context, widget._session.name),
        trailing: _newWorkoutButton(),
      ),
      child: SafeArea(
        top: true,
        child: Container(
          color: Styles.defaultBackground(context),
          child: ListView(
              children: [
                    _infoSection(context),
                  ] +
                  (_loadingInitialList
                      ? [
                          Container(
                            height: 15,
                          ),
                          const CupertinoActivityIndicator()
                        ]
                      : _workouts.map((Workout wo) {
                          return WorkoutListItem(widget._session, wo,
                              widget._exerciseMap, _loadWorkouts);
                        }).toList())),
        ),
      ),
    );
  }
}
