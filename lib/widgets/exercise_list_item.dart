import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ExerciseListItem extends StatelessWidget {
  String _exerciseId, _exerciseName;

  ExerciseListItem(this._exerciseId, this._exerciseName);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(
          top: 10,
          bottom: 10,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.amberAccent,
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(_exerciseName),
              Icon(CupertinoIcons.ellipsis),
            ],
          ),
        ));
  }
}
