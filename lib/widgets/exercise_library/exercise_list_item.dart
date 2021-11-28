import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:liftlogmobile/models/exercise.dart';
import 'package:liftlogmobile/services/api_service.dart';
import 'package:liftlogmobile/utils/styles.dart';

class _EditExerciseDialog extends StatelessWidget {
  final Exercise _exercise;
  final Function _reloadExercises;
  final TextEditingController _exerciseNameController = TextEditingController();

  _EditExerciseDialog(this._exercise, this._reloadExercises) {
    _exerciseNameController.text = _exercise.name;
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text(
        "Edit Exercise Name",
        style: Styles.dialogTitle(context),
      ),
      content: Column(
        children: [
          Container(
            height: 10,
          ),
          CupertinoTextField(
            controller: _exerciseNameController,
          )
        ],
      ),
      actions: <Widget>[
        CupertinoDialogAction(
          child: Text("Cancel", style: Styles.dialogActionNormal(context)),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        CupertinoDialogAction(
          child: Text(
            "Save",
            style: Styles.dialogActionNormal(context),
          ),
          onPressed: () async {
            String newName = _exerciseNameController.text;
            bool updated = await APIService.updateExercise(_exercise, newName);
            if (updated) {
              _reloadExercises();
              Navigator.pop(context);
              Navigator.pop(context);
            }
          },
        )
      ],
    );
  }
}

class _DeleteExerciseDialog extends StatelessWidget {
  final Exercise _exercise;
  final Function _reloadExercises;

  const _DeleteExerciseDialog(this._exercise, this._reloadExercises);

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text("Delete Exercise", style: Styles.dialogTitle(context)),
      content: Text("Are you sure?", style: Styles.dialogContent(context)),
      actions: <Widget>[
        CupertinoDialogAction(
          child: Text(
            "Cancel",
            style: Styles.dialogActionNormal(context),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        CupertinoDialogAction(
          child: Text(
            "Delete",
            style: Styles.dialogActionCrucial(context),
          ),
          onPressed: () async {
            bool deleted = await APIService.deleteExercise(_exercise);
            if (deleted) {
              _reloadExercises();
              Navigator.pop(context);
              Navigator.pop(context);
            }
          },
        )
      ],
    );
  }
}

class ExerciseListItem extends StatelessWidget {
  final Exercise _exercise;
  final Function _reloadExercises;

  ExerciseListItem(this._exercise, this._reloadExercises);

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
                          return _EditExerciseDialog(
                              _exercise, _reloadExercises);
                        },
                      );
                    },
                    child: const Text("Edit"),
                  ),
                  CupertinoActionSheetAction(
                    onPressed: () {
                      showCupertinoDialog(
                        context: context,
                        builder: (BuildContext buildContext) {
                          return _DeleteExerciseDialog(
                              _exercise, _reloadExercises);
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
            Padding(
              padding: const EdgeInsets.only(left: 15, top: 10, bottom: 10),
              child: Text(
                _exercise.name,
                style: Styles.exerciseItemHeader(context),
              ),
            ),
            _ellipsisOptions(context),
          ],
        ),
      ),
    );
  }
}
