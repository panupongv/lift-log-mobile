import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:liftlogmobile/models/user.dart';
import 'package:liftlogmobile/services/api_service.dart';

class _AddExerciseDialog extends StatelessWidget {
  Function _reloadExercises;
  TextEditingController _exerciseNameController = new TextEditingController();

  _AddExerciseDialog(this._reloadExercises);

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text("Enter Exercise Name"),
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
            //style: Styles.dialogActionNormal(context),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        CupertinoDialogAction(
          child: Text(
            "Create",
            //style: Styles.dialogActionNormal(context),
          ),
          onPressed: () async {
            String name = _exerciseNameController.text;
            bool created =
                await APIService.createExercise(name);
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
  Function _reloadExercise;

  AddExerciseItem(this._reloadExercise);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.transparent),
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                CupertinoIcons.add_circled,
                color: Colors.lightGreen,
              ),
              Container(
                width: 5,
              ),
              Padding(
                padding: EdgeInsets.only(top: 10, bottom: 10),
                child: Text("Add Exercise"),
              ),
            ],
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
