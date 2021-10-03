import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:liftlogmobile/screens/authentication/login_screen.dart';
import 'package:liftlogmobile/services/local_storage_service.dart';
import 'package:liftlogmobile/widgets/navigation_bar_text.dart';

class ExerciseLibraryTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        trailing: navigationBarTextButton(context, "Logout", () async {
          await LocalStorageService.removeSavedUser();
          CupertinoPageRoute backToLoginRoute =
              CupertinoPageRoute(builder: (context) => LoginScreen());
          Navigator.pushReplacement(context, backToLoginRoute);
        }),
      ),
      child: Text("Exercises"),
    );
  }
}
