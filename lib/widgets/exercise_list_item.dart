import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:liftlogmobile/models/exercise.dart';
import 'package:liftlogmobile/models/user.dart';
import 'package:liftlogmobile/services/api_service.dart';
import 'package:liftlogmobile/widgets/quick_dialog.dart';

class _EditExerciseDialog extends StatelessWidget {
  Exercise _exercise;
  Function _reloadExercises;
  TextEditingController _exerciseNameController = new TextEditingController();

  _EditExerciseDialog(this._exercise, this._reloadExercises) {
    _exerciseNameController.text = _exercise.name;
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text("Edit Exercise Name"),
      content: CupertinoTextField(
        controller: _exerciseNameController,
      ),
      actions: <Widget>[
        CupertinoDialogAction(
          child: Text(
            "Cancel",
            //style: Styles.dialogActionNormal(context),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        CupertinoDialogAction(
          child: Text(
            "Save",
            //style: Styles.dialogActionNormal(context),
          ),
          onPressed: () async {
            String newName = _exerciseNameController.text;
            bool updated = await APIService.updateExercise(
                GlobalUser.user!, _exercise, newName);
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
  Exercise _exercise;
  Function _reloadExercises;
  _DeleteExerciseDialog(this._exercise, this._reloadExercises);

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text("Delete Exercise"),
      content: Text("Are you sure?"),
      actions: <Widget>[
        CupertinoDialogAction(
          child: Text(
            "Cancel",
            //style: Styles.dialogActionNormal(context),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        CupertinoDialogAction(
          child: Text(
            "Delete",
            //style: Styles.dialogActionNormal(context),
          ),
          onPressed: () async {
            bool deleted =
                await APIService.deleteExercises(GlobalUser.user!, _exercise);
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
  //String _exerciseId, _exerciseName;

  //ExerciseListItem(this._exerciseId, this._exerciseName);

  Exercise _exercise;
  Function _reloadExercises;

  ExerciseListItem(this._exercise, this._reloadExercises);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Container(
        decoration: BoxDecoration(
          //color: Colors.amberAccent,
          border: Border.all(color: Colors.greenAccent),
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 10, top: 10, bottom: 10),
              child: Text(_exercise.name),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 10, top: 10, bottom: 10),
              child: GestureDetector(
                child: Icon(CupertinoIcons.ellipsis),
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
                          child: Text(
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
            ),

            //CupertinoContextMenu(
            //  child: Padding(
            //    padding: EdgeInsets.only(right: 10, top: 10, bottom: 10),
            //    child: Icon(CupertinoIcons.ellipsis),
            //  ),
            //  actions: [
            //    CupertinoContextMenuAction(
            //      child: Text("Edit"),
            //      onPressed: () {
            //        //Navigator.pop(context);
            //        showCupertinoDialog(
            //            context: context,
            //            builder: (BuildContext buildContext) {
            //              return _EditExerciseDialog(_exercise, _reloadExercises);
            //            });
            //      },
            //    ),
            //    CupertinoContextMenuAction(
            //      child: Text("Delete"),
            //      onPressed: () {},
            //    ),
            //  ],
            //),
          ],
        ),
      ),
    );
  }
}
