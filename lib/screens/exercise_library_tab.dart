import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:liftlogmobile/screens/login_screen.dart';
import 'package:liftlogmobile/services/local_storage_service.dart';
import 'package:liftlogmobile/widgets/navigation_bar_text.dart';

class ExerciseLibraryTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        automaticallyImplyLeading: false,
        trailing: navigationBarTextButton(context, "Logout", () async {
          showCupertinoDialog(
              context: context,
              builder: (BuildContext context) {
                return CupertinoAlertDialog(
                  title: Text("Logout"),
                  content: Text("Are you sure?"),
                  actions: <Widget>[
                    CupertinoDialogAction(
                      child: Text(
                        "Cancel",
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    CupertinoDialogAction(
                      child: Text(
                        "Confirm",
                      ),
                      onPressed: () async {
                        await LocalStorageService.removeSavedUser();
                        CupertinoPageRoute backToLoginRoute =
                            CupertinoPageRoute(
                                builder: (context) => LoginScreen());
                        Navigator.pushReplacement(context, backToLoginRoute);
                      },
                    )
                  ],
                );
              });
        }),
      ),
      child: Text("Exercises"),
    );
  }
}
