import 'package:flutter/cupertino.dart';
import 'package:liftlogmobile/models/exercise.dart';
import 'package:liftlogmobile/models/workout.dart';
import 'package:liftlogmobile/utils/styles.dart';
import 'package:liftlogmobile/widgets/shared/navigation_bar_text.dart';

class WorkoutScreen extends StatelessWidget {
  final Workout? _workout;
  final Map<String, Exercise> _exerciseMap;
  List<Exercise> _exercises = [];

  WorkoutScreen(this._workout, this._exerciseMap) {
    _exercises = _exerciseMap.values.toList();
  }

  Widget _exercisePicker() {
    return Container(
      height: 100,
      child: CupertinoPicker(
          itemExtent: 40,
          onSelectedItemChanged: (int index) {
            print(_exercises[index].toString());
          },
          children: _exercises.map((e) => Text(e.name)).toList()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: navigationBarTitle(context, "Workout Details"),
      ),
      child: SafeArea(
        top: true,
        child: Container(
          color: Styles.defaultBackground(context),
          child: ListView(children: [_exercisePicker()]),
        ),
      ),
    );
  }
}
