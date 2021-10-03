import 'package:dartz/dartz.dart' as dz;
import 'package:flutter/cupertino.dart';

import 'package:liftlogmobile/lift_log_app.dart';
import 'package:liftlogmobile/models/user.dart';
import 'package:liftlogmobile/screens/authentication/signup_screen.dart';
import 'package:liftlogmobile/services/api_service.dart';
import 'package:liftlogmobile/services/local_storage_service.dart';
import 'package:liftlogmobile/utils/auth_field_validator.dart';
import 'package:liftlogmobile/widgets/quick_dialog.dart';

import '../../widgets/auth_text_field.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
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
            CupertinoButton(
              child: const Text("Login"),
              onPressed: () async {
                String username = _usernameController.text;
                String password = _passwordController.text;

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
                      CupertinoPageRoute mainAppRoute = CupertinoPageRoute(
                          builder: (context) => LiftLogApp(user));
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
              },
            ),
            Container(
              height: 50,
            ),
            CupertinoButton(
              child: Text("No account? Sign up here"),
              onPressed: () async {
                CupertinoPageRoute signupPageRoute =
                    CupertinoPageRoute(builder: (context) => SignUpScreen());
                dynamic usernameAndPassword = await Navigator.push(
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
