import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:liftlogmobile/lift_log_app.dart';
import 'package:liftlogmobile/models/exercise.dart';
import 'package:liftlogmobile/models/user.dart';
import 'package:liftlogmobile/screens/login_screen.dart';
import 'package:liftlogmobile/services/local_storage_service.dart';
import 'package:liftlogmobile/widgets/exercise_list_item.dart';
import 'package:liftlogmobile/widgets/navigation_bar_text.dart';

class ExerciseLibraryTab extends StatelessWidget {
  Function _reloadExercises;
  List<Exercise> _exercises;

  ExerciseLibraryTab(this._reloadExercises, this._exercises);

  Widget _logoutButton(BuildContext context) {
    return navigationBarTextButton(
      context,
      "Logout",
      () async {
        showCupertinoDialog(
          context: context,
          builder: (BuildContext context) {
            return CupertinoAlertDialog(
              title: const Text("Logout"),
              content: const Text("Are you sure?"),
              actions: <Widget>[
                CupertinoDialogAction(
                  child: const Text(
                    "Cancel",
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                CupertinoDialogAction(
                  child: const Text(
                    "Confirm",
                  ),
                  onPressed: () async {
                    await LocalStorageService.removeSavedUser();
                    CupertinoPageRoute backToLoginRoute =
                        CupertinoPageRoute(builder: (context) => LoginScreen());
                    Navigator.pushReplacement(context, backToLoginRoute);
                  },
                )
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        automaticallyImplyLeading: false,
        middle: Text("My Exercises"),
        trailing: _logoutButton(context),
      ),
      child: SafeArea(
        top: true,
        child: ListView(
          children: _exercises.map((ex) {
            return ExerciseListItem(ex.id, ex.name);
            //return Card(child: ListTile(title: Text(e.name),),);            
          }).toList(),
        ),
      ),
    );
  }
}
