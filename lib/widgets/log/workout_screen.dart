import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    _scrollController =
        FixedExtentScrollController(initialItem: _selectedIndex);
  }

  @override
  State<WorkoutScreen> createState() => _WorkoutScreenState();
}

class _ContentRow extends StatelessWidget {
  int _index;
  bool _isMoveUpAvailable = true;
  bool _isMoveDownAvailable = true;
  final Function _swapCallback;

  final TextEditingController _weightTextController = TextEditingController();
  final TextEditingController _repsTextController = TextEditingController();

  _ContentRow(
      this._index, int listSize, String weightAndReps, this._swapCallback) {
    List<String> weightAndRepsSplit =
        weightAndReps.split(Workout.weightRepsSeparator);
    _weightTextController.text = weightAndRepsSplit[0];
    _repsTextController.text = weightAndRepsSplit[1];
    setIndex(_index, listSize);
  }

  _ContentRow clone() =>
      _ContentRow(_index, 0, _rawWeightAndReps(), _swapCallback);

  void setIndex(int newIndex, int listSize) {
    _index = newIndex;
    _isMoveUpAvailable = _index > 0;
    _isMoveDownAvailable = _index < listSize - 1;
  }

  String _rawWeightAndReps() =>
      "${_weightTextController.text}${Workout.weightRepsSeparator}${_repsTextController.text}";

  String? get weightAndReps {
    if (_weightTextController.text.isNotEmpty &&
        _repsTextController.text.isNotEmpty) {
      return _rawWeightAndReps();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          color: Styles.listItemBackground(context),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 4, top: 4, bottom: 4),
              child: SizedBox(
                width: 50,
                child: CupertinoTextField(
                  keyboardType: TextInputType.number,
                  controller: _weightTextController,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 4, top: 4, bottom: 4),
              child: SizedBox(
                width: 50,
                child: CupertinoTextField(
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                  ],
                  controller: _repsTextController,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  child: Icon(
                    CupertinoIcons.up_arrow,
                    color: _isMoveUpAvailable
                        ? Styles.activeColor(context)
                        : Styles.inactiveColor(context),
                  ),
                  onTap: () {
                    if (_isMoveUpAvailable) {
                      _swapCallback(_index, -1);
                    }
                  },
                ),
                GestureDetector(
                  child: Icon(
                    CupertinoIcons.down_arrow,
                    color: _isMoveDownAvailable
                        ? Styles.activeColor(context)
                        : Styles.inactiveColor(context),
                  ),
                  onTap: () {
                    if (_isMoveDownAvailable) {
                      _swapCallback(_index, 1);
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _WorkoutScreenState extends State<WorkoutScreen> {
  bool _saving = false;
  late List<_ContentRow> _rows;

  @override
  void initState() {
    List<String> _contentList = widget._workout.sets > 0
        ? widget._workout.content.split(Workout.setSeparator)
        : [];
    _rows = List<_ContentRow>.generate(
      _contentList.length,
      (index) {
        return _ContentRow(
            index, _contentList.length, _contentList[index], _swapRows);
      },
    );
  }

  void _swapRows(int index, int direction) {
    _ContentRow temp = _rows[index];
    int targetIndex = index + direction;
    int rowsLength = _rows.length;
    setState(() {
      _rows[index] = _rows[targetIndex];
      _rows[targetIndex] = temp;
      _rows[index].setIndex(index, rowsLength);
      _rows[targetIndex].setIndex(targetIndex, rowsLength);
    });
  }

  String? _extractContentFromWidget() {
    String sets = "";
    for (int i = 0; i < _rows.length; i++) {
      String? rowContent = _rows[i].weightAndReps;
      if (rowContent == null) {
        return null;
      }
      sets += "$rowContent${Workout.setSeparator}";
    }
    if (sets.isNotEmpty && sets[sets.length - 1] == Workout.setSeparator) {
      sets = sets.substring(0, sets.length - 1);
    }
    if (!Workout.validateContent(sets)) {
      return null;
    }
    return sets;
  }

  Widget _saveButton(context) {
    return navigationBarTextButton(context, "Save", () async {
      setState(() {
        _saving = true;
      });

      String? content = _extractContentFromWidget();
      print("Cont: $content");

      if (content == null) {
        await showCupertinoDialog(
          context: context,
          builder: (buildContext) => quickAlertDialog(
              buildContext,
              "Error Saving",
              "Please fill in the valid details for each set.",
              "Dismiss"),
        );
        setState(() {
          _saving = false;
        });
        return;
      }

      Workout originalWorkout = widget._workout;
      Workout updatedWorkout = Workout(
        originalWorkout.id,
        widget._exercises[widget._selectedIndex].id,
        content,
      );

      bool updated =
          await APIService.updateWorkout(widget._session, updatedWorkout);
      if (updated) {
        Navigator.pop(context, true);
      } else {
        showCupertinoDialog(
          context: context,
          builder: (buildContext) => quickAlertDialog(buildContext,
              "Error Saving", "Failed to save the session.", "Dismiss"),
        );
      }

      setState(() {
        _saving = false;
      });
    }, isActive: !_saving);
  }

  Widget _exercisePickerItem(Exercise exercise) {
    return Text(exercise.name, style: Styles.exercisePicker(context));
  }

  Widget _exercisePicker() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Styles.exercisePickerBackground(context),
          borderRadius: BorderRadius.circular(8),
        ),
        height: 120,
        child: CupertinoPicker(
            scrollController: widget._scrollController,
            itemExtent: 28,
            onSelectedItemChanged: (int selectedIndex) {
              widget._selectedIndex = selectedIndex;
            },
            children:
                widget._exercises.map((e) => _exercisePickerItem(e)).toList()),
      ),
    );
  }

  Widget _addSetButton() {
    return Container(
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.only(top: 4, bottom: 8),
        child: GestureDetector(
          child: Container(
            decoration: BoxDecoration(
              color: Styles.listItemBackground(context),
              borderRadius: const BorderRadius.all(Radius.circular(8)),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 15),
              child: Text(
                "Add Set",
                style: Styles.addSetButton(context),
              ),
            ),
          ),
          onTap: () {
            if (_rows.isNotEmpty) {
              int previousLastIndex = _rows.length - 1;
              _ContentRow previousLastRow = _rows[previousLastIndex].clone();
              previousLastRow.setIndex(previousLastIndex, _rows.length + 1);
              setState(() {
                _rows[previousLastIndex] = previousLastRow;
              });
            }
            _ContentRow newRow = _ContentRow(
              _rows.length,
              _rows.length + 1,
              Workout.weightRepsSeparator,
              _swapRows,
            );
            _rows += [newRow];
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: Styles.defaultBackground(context),
      navigationBar: CupertinoNavigationBar(
        middle: navigationBarTitle(context, "Workout Details"),
        trailing: _saveButton(context),
      ),
      child: SafeArea(
        top: true,
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 8, top: 8),
                child: Text("Select Exercise:",
                    style: Styles.workoutScreenLabels(context)),
              ),
            ),
            _exercisePicker(),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 8, top: 8),
                child:
                    Text("Content", style: Styles.workoutScreenLabels(context)),
              ),
            ),
            Expanded(
              child: ListView(
                children: List<Widget>.generate(
                      _rows.length,
                      (int index) => _rows[index],
                    ) +
                    //children: _rows.map((e){return (Widget)e;}).toList() +
                    <Widget>[_addSetButton()],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
