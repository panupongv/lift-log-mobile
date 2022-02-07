import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:liftlogmobile/models/user.dart';
import 'package:liftlogmobile/services/api_service.dart';
import 'package:liftlogmobile/utils/styles.dart';

class _AddExerciseDialog extends StatelessWidget {
  final Function _reloadExercises;
  final TextEditingController _exerciseNameController = TextEditingController();

  _AddExerciseDialog(this._reloadExercises);

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text("Enter Exercise Name", style: Styles.dialogTitle(context)),
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
            "Create",
            style: Styles.dialogActionNormal(context),
          ),
          onPressed: () async {
            String name = _exerciseNameController.text;
            bool created = await APIService.createExercise(name);
            if (created) {
              _reloadExercises();
              Navigator.pop(context);
            }
          },
        )
      ],
    );
  }
}

class AddExerciseItem extends StatelessWidget {
  final Function _reloadExercise;

  AddExerciseItem(this._reloadExercise);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Padding(
        padding: const EdgeInsets.only(top: 15),
        child: Container(
          alignment: Alignment.center,
          child: Container(
            decoration: BoxDecoration(
              color: Styles.listItemBackground(context),
              borderRadius: const BorderRadius.all(Radius.circular(8)),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 15),
              child: Text(
                "Add Exercise",
                style: Styles.addExercise(context),
              ),
            ),
          ),
        ),
      ),
      onTap: () {
        showCupertinoDialog(
          context: context,
          builder: (BuildContext context) {
            return _AddExerciseDialog(_reloadExercise);
          },
        );
      },
    );
  }
}
