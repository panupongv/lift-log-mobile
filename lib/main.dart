import 'dart:io';

import 'package:flutter/material.dart';
import 'package:liftlogmobile/lift_log_app.dart';
import 'package:liftlogmobile/screens/authentication/login_screen.dart';
import 'package:liftlogmobile/services/local_storage_service.dart';

import 'models/user.dart';

String baseUrl = "https://lift-log-prod.herokuapp.com/api";

void main() {
  runApp(EntryPoint());
}

class EntryPoint extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FutureBuilder(
        future: LocalStorageService.loadSavedUser(),
        builder: (BuildContext context, AsyncSnapshot<User?> currentUser) {
          if (currentUser.data != null) {
            return LiftLogApp();
          } else {
            return LoginScreen();
          }
        },
      ),
    );
  }
}
