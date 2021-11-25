import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:liftlogmobile/lift_log_app.dart';
import 'package:liftlogmobile/screens/auth/login_screen.dart';
import 'package:liftlogmobile/services/local_storage_service.dart';

import 'models/user.dart';

void main() {
  runApp(const EntryPoint());
}

class EntryPoint extends StatelessWidget {
  const EntryPoint({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      home: FutureBuilder(
        future: LocalStorageService.loadSavedUser(),
        builder: (BuildContext context, AsyncSnapshot<User?> currentUser) {
          if (currentUser.data != null) {
            GlobalUser.user = currentUser.data!;
            print("Logging in as ${GlobalUser.user!.username}");
            return LiftLogApp();
          } else {
            return LoginScreen();
          }
        },
      ),
    );
  }
}
