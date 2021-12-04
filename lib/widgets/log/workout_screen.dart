import 'package:flutter/cupertino.dart';
import 'package:liftlogmobile/models/exercise.dart';
import 'package:liftlogmobile/models/session.dart';
import 'package:liftlogmobile/models/workout.dart';
import 'package:liftlogmobile/services/api_service.dart';
import 'package:liftlogmobile/utils/styles.dart';
import 'package:liftlogmobile/widgets/shared/navigation_bar_text.dart';
import 'package:liftlogmobile/widgets/shared/quick_dialog.dart';

class WorkoutScreen extends StatefulWidget {
  final Session _session;
  final Workout _workout;
  final Map<String, Exercise> _exerciseMap;
  List<Exercise> _exercises = [];
  int _selectedIndex = 0;
  FixedExtentScrollController _scrollController = FixedExtentScrollController();

  WorkoutScreen(this._session, this._workout, this._exerciseMap) {
    _exercises = [Exercise(Workout.defaultIdReference, "None")] +
        _exerciseMap.values.toList();
    int index =
        _exercises.indexWhere((element) => element.id == _workout.exerciseId);
    _selectedIndex = index == -1 ? 0 : index;
    print("Index found: $_selectedIndex");
    _scrollController =
        FixedExtentScrollController(initialItem: _selectedIndex);
  }

  @override
  State<WorkoutScreen> createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends State<WorkoutScreen> {
  bool _saving = false;

  Widget _saveButton(context) {
    return navigationBarTextButton(context, "Save", () async {
      setState(() {
        _saving = true;
      });
      Workout originalWorkout = widget._workout;
      Workout updatedWorkout = Workout(
        originalWorkout.id,
        widget._exercises[widget._selectedIndex].id,
        originalWorkout.content,
      );

      bool updated =
          await APIService.updateWorkout(widget._session, updatedWorkout);
      if (updated) {
        Navigator.pop(context, true);
      } else {
        showCupertinoDialog(
            context: context,
            builder: (buildContext) => quickAlertDialog(buildContext,
                "Error Saving", "Failed to create the session.", "Dismiss"));
      }

      setState(() {
        _saving = false;
      });
    }, isActive: !_saving);
  }

  Widget _exercisePickerItem(Exercise exercise) {
    return Text(exercise.name);
  }

  Widget _exercisePicker() {
    return Container(
        height: 100,
        child: CupertinoPicker(
            scrollController: widget._scrollController,
            itemExtent: 40,
            onSelectedItemChanged: (int selectedIndex) {
              widget._selectedIndex = selectedIndex;
            },
            children:
                widget._exercises.map((e) => _exercisePickerItem(e)).toList()));
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: navigationBarTitle(context, "Workout Details"),
        trailing: _saveButton(context),
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
