import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:liftlogmobile/models/exercise.dart';
import 'package:liftlogmobile/models/session.dart';
import 'package:liftlogmobile/models/workout.dart';
import 'package:liftlogmobile/services/api_service.dart';
import 'package:liftlogmobile/utils/styles.dart';
import 'package:liftlogmobile/widgets/log/workout_history_screen.dart';
import 'package:liftlogmobile/widgets/shared/navigation_bar_text.dart';
import 'package:liftlogmobile/widgets/shared/quick_dialog.dart';

class _ContentRow extends StatelessWidget {
  int _index;
  bool _isMoveUpAvailable = true;
  bool _isMoveDownAvailable = true;
  final Function _swapCallback;
  final Function _removeRowCallback;

  final TextEditingController _weightTextController = TextEditingController();
  final TextEditingController _repsTextController = TextEditingController();

  _ContentRow(this._index, int listSize, String weightAndReps,
      this._swapCallback, this._removeRowCallback) {
    List<String> weightAndRepsSplit =
        weightAndReps.split(Workout.weightRepsSeparator);
    _weightTextController.text = weightAndRepsSplit[0];
    _repsTextController.text = weightAndRepsSplit[1];
    setIndex(_index, listSize);
  }

  _ContentRow clone() => _ContentRow(
      _index, 0, _rawWeightAndReps(), _swapCallback, _removeRowCallback);

  void setIndex(int newIndex, int listSize) {
    _index = newIndex;
    _isMoveUpAvailable = _index > 0;
    _isMoveDownAvailable = _index < listSize - 1;
  }

  String deb() => "$_index $_isMoveUpAvailable $_isMoveDownAvailable";

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
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 4, top: 4, bottom: 4),
                  child: SizedBox(
                    //height: 30,
                    width: 50,
                    child: CupertinoTextField(
                      keyboardType: TextInputType.number,
                      controller: _weightTextController,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 4, right: 12),
                  child: Text(
                    "kg",
                    style: Styles.contentRowLabel(context),
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
                Padding(
                  padding: const EdgeInsets.only(left: 4, right: 8),
                  child: Text(
                    "reps",
                    style: Styles.contentRowLabel(context),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: GestureDetector(
                        child: Icon(
                          CupertinoIcons.chevron_up,
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
                    ),
                    Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: GestureDetector(
                        child: Icon(
                          CupertinoIcons.chevron_down,
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
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 4, right: 6),
                  child: GestureDetector(
                    child: const Icon(CupertinoIcons.delete),
                    onTap: () {
                      _removeRowCallback(_index);
                    },
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class WorkoutScreen extends StatefulWidget {
  final Session _session;
  Workout _workout;
  final Map<String, Exercise> _exerciseMap;
  
  WorkoutScreen(this._session, this._workout, this._exerciseMap);

  @override
  State<WorkoutScreen> createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends State<WorkoutScreen> {
  bool _saving = false;
  late List<_ContentRow> _rows;
  List<Exercise> _exercises = [];
  int _selectedIndex = 0;
  int _savedIndex = 0;
  FixedExtentScrollController _scrollController = FixedExtentScrollController();

  @override
  void initState() {
    _exercises = [Exercise(Workout.defaultIdReference, "None")] +
        widget._exerciseMap.values.toList();
    print("Exercise List: $_exercises");
    print(widget._workout.exerciseId);
    int searchIndex =
        _exercises.indexWhere((element) => element.id == widget._workout.exerciseId);
    int _selectedIndex = searchIndex == -1 ? 0 : searchIndex;
    _savedIndex = _selectedIndex;
    _scrollController =
        FixedExtentScrollController(initialItem: _selectedIndex);

    print("Search: $searchIndex");
    print("Initial Selected: $_selectedIndex");
    print("Workout: ${widget._workout}");


    List<String> _contentList = widget._workout.sets > 0
        ? widget._workout.content.split(Workout.setSeparator)
        : [];
    _rows = List<_ContentRow>.generate(
      _contentList.length,
      (index) {
        return _ContentRow(index, _contentList.length, _contentList[index],
            _swapRows, _removeRow);
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

  void _removeRow(int index) {
    print("Before remove: ${widget._workout}");
    print("Current Index: ${_selectedIndex}");
    setState(() {
      _rows.removeAt(index);
    });

    List<_ContentRow> updatedRows = [];
    int rowsLength = _rows.length;
    for (int i = 0; i < _rows.length; i++) {
      _ContentRow updatedRow = _rows[i].clone();
      updatedRow.setIndex(i, rowsLength);
      updatedRows.add(updatedRow);
    }
    setState(() {
      _rows = updatedRows;
    });
    print("After remove: ${widget._workout}");
    print("Current Index: ${_selectedIndex}");
  }

  String? _extractContentFromWidget() {
    String setsString = "";
    for (int i = 0; i < _rows.length; i++) {
      String? rowContent = _rows[i].weightAndReps;
      if (rowContent == null) {
        return null;
      }
      setsString += "$rowContent${Workout.setSeparator}";
    }
    if (setsString.isNotEmpty &&
        setsString[setsString.length - 1] == Workout.setSeparator) {
      setsString = setsString.substring(0, setsString.length - 1);
    }
    if (!Workout.validateContent(setsString)) {
      return null;
    }
    return setsString;
  }

  Widget _saveButton(context) {
    return navigationBarTextButton(context, "Save", () async {
      final int currentSelectedIndex = _selectedIndex;
      print("Current Index: $currentSelectedIndex");

      setState(() {
        _saving = true;
      });

      String? content = _extractContentFromWidget();

      if (content == null) {
        await showCupertinoDialog(
          context: context,
          builder: (buildContext) => quickAlertDialog(
            buildContext,
            "Error Saving",
            "Please fill in the valid details for each set.",
            "Dismiss",
          ),
        );
        setState(() {
          _saving = false;
        });
        return;
      }

      Workout originalWorkout = widget._workout;
      Workout updatedWorkout = Workout(
        originalWorkout.id,
        _exercises[currentSelectedIndex].id,
        content,
      );

      print("To Save Workout: $updatedWorkout");

      bool updated = await APIService.updateWorkout(
        widget._session,
        updatedWorkout,
      );
      if (updated) {
        setState(() {
          widget._workout = updatedWorkout;
          _savedIndex = currentSelectedIndex;
        });
      } else {
        showCupertinoDialog(
          context: context,
          builder: (buildContext) => quickAlertDialog(
            buildContext,
            "Error Saving",
            "Failed to save the session.",
            "Dismiss",
          ),
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
          scrollController: _scrollController,
          itemExtent: 28,
          onSelectedItemChanged: (int selectedIndex) {
            setState(() {
              _selectedIndex = selectedIndex;
            });

            print("Selected ${_selectedIndex}");
            print("Saved ${_savedIndex}");
          },
          children:
              _exercises.map((e) => _exercisePickerItem(e)).toList(),
        ),
      ),
    );
  }

  Widget _contentLabel() => Padding(
        padding: const EdgeInsets.only(left: 8),
        child: Text("Content", style: Styles.workoutScreenLabels(context)),
      );

  Widget _historyButton() {
    bool available =
        _savedIndex != 0 && _savedIndex == _selectedIndex;
    return GestureDetector(
      child: Padding(
        padding: const EdgeInsets.only(right: 8),
        child: Text(
          "See History",
          style: Styles.historyButton(context, available),
        ),
      ),
      onTap: () async {
        if (!available) {
          showCupertinoDialog(
              context: context,
              builder: (context) => quickAlertDialog(
                  context,
                  "Unable to see History",
                  _savedIndex == 0
                      ? "Please select a valid exercise and save to see the history."
                      : "The exercise must be up to date to see the history.",
                  "Dismiss"));
          return;
        }

        CupertinoPageRoute historyPageRoute = CupertinoPageRoute(
            builder: (BuildContext context) => WorkoutHistoryScreen(
                  widget._session,
                  _exercises[_selectedIndex],
                ));
        await Navigator.push(context, historyPageRoute);
      },
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
            print("Before add: ${widget._workout}");
            print("Current Index: ${_selectedIndex}");
            if (_rows.isNotEmpty) {
              int previousLastIndex = _rows.length - 1;
              _ContentRow previousLastRow = _rows[previousLastIndex].clone();
              previousLastRow.setIndex(previousLastIndex, _rows.length + 1);
              setState(() {
                _rows[previousLastIndex] = previousLastRow;
              });
            }
            _ContentRow newRow = _ContentRow(_rows.length, _rows.length + 1,
                Workout.weightRepsSeparator, _swapRows, _removeRow);
            setState(() {
              _rows += [newRow];
            });
            print("After add: ${widget._workout}");
            print("Current Index: ${_selectedIndex}");
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
            Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _contentLabel(),
                  _historyButton(),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                children: List<Widget>.generate(
                      _rows.length,
                      (int index) => _rows[index],
                    ) +
                    <Widget>[_addSetButton()],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
