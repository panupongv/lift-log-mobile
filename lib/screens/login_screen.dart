import 'package:dartz/dartz.dart' as dz;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:liftlogmobile/lift_log_app.dart';
import 'package:liftlogmobile/models/user.dart';
import 'package:liftlogmobile/screens/signup_screen.dart';
import 'package:liftlogmobile/services/api_service.dart';
import 'package:liftlogmobile/services/local_storage_service.dart';
import 'package:liftlogmobile/utils/auth_field_validator.dart';
import 'package:liftlogmobile/utils/styles.dart';
import 'package:liftlogmobile/widgets/quick_dialog.dart';

import '../../widgets/auth_text_field.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _buttonAvailable = true;

  void _submitLogin() async {
    String username = _usernameController.text;
    String password = _passwordController.text;

    setState(() {
      _buttonAvailable = false;
    });

    if (AuthFieldValidator.hasEmptyField([username, password])) {
      showCupertinoDialog(
        context: context,
        builder: (context) => quickAlertDialog(
          context,
          "Login Failed",
          "Please fill in all the fields.",
          "Dismiss",
        ),
      );
    } else {
      dz.Either<User, String> loginResult =
          await APIService.login(username, password);
      loginResult.fold(
        (User user) {
          LocalStorageService.saveUser(user);
          CupertinoPageRoute mainAppRoute =
              CupertinoPageRoute(builder: (context) => LiftLogApp(user));
          Navigator.pushReplacement(context, mainAppRoute);
        },
        (String errorMessage) {
          showCupertinoDialog(
            context: context,
            builder: (context) => quickAlertDialog(
              context,
              "Login Failed",
              errorMessage,
              "Dismiss",
            ),
          );
        },
      );
    }
    setState(() {
      _buttonAvailable = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        automaticallyImplyLeading: false,
        middle: Text("Lift Log"),
      ),
      child: Center(
        child: ListView(
          shrinkWrap: true,
          children: [
            authenticationTextField(
              "Username",
              _usernameController,
            ),
            authenticationTextField(
              "Password",
              _passwordController,
              obsecureText: true,
            ),
            Container(
              height: 20,
            ),
            UnconstrainedBox(
              child: CupertinoButton.filled(
                disabledColor: Styles.disabledAuthButton(),
                borderRadius: const BorderRadius.all(Radius.circular(8)),
                child: _buttonAvailable ? const Text("Login") : const Text("Processing"),
                onPressed: _buttonAvailable ? _submitLogin : null,
              ),
            ),
            Container(
              height: 40,
            ),
            CupertinoButton(
              child: const Text("Create account"),
              onPressed: () async {
                CupertinoPageRoute signupPageRoute =
                    CupertinoPageRoute(builder: (context) => SignUpScreen());
                dynamic usernameAndPassword = await Navigator.pushReplacement(
                  context,
                  signupPageRoute,
                );
                if (usernameAndPassword is List) {
                  setState(() {
                    _usernameController.text = usernameAndPassword[0];
                    _passwordController.text = usernameAndPassword[1];
                  });
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
