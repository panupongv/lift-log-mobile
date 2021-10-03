import 'package:dartz/dartz.dart' as dz;
import 'package:flutter/cupertino.dart';
import 'package:liftlogmobile/widgets/auth_text_field.dart';
import 'package:liftlogmobile/services/api_service.dart';
import 'package:liftlogmobile/utils/auth_field_validator.dart';
import 'package:liftlogmobile/widgets/quick_dialog.dart';

class SignUpScreen extends StatefulWidget {
  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController _usernameController = TextEditingController(),
      _passwordController = TextEditingController(),
      _confirmPasswordController = TextEditingController();

  Widget _submitButton(BuildContext context) => CupertinoButton(
        child: const Text("Submit"),
        onPressed: () async {
          String username = _usernameController.text;
          String password1 = _passwordController.text;
          String password2 = _confirmPasswordController.text;
          String? errorMessage;

          if (AuthFieldValidator.hasEmptyField(
              [username, password1, password2])) {
            errorMessage = "Please fill in all the fields.";
          } else if (AuthFieldValidator.passwordTooShort(password1)) {
            errorMessage = "Password too short.";
          } else if (AuthFieldValidator.passwordMismatch(
              password1, password2)) {
            errorMessage = "Passwords do not match";
          }

          if (errorMessage != null) {
            showCupertinoDialog(
                context: context,
                builder: (BuildContext context) => quickAlertDialog(
                    context, "Signup Failed", errorMessage, "Dismiss"));
          } else {
            dz.Either<bool, String> signupResult =
                await APIService.signup(username, password1);
            if (signupResult.isLeft()) {
              showCupertinoDialog(
                context: context,
                builder: (BuildContext context) => CupertinoAlertDialog(
                  content: Text(signupResult
                      .getOrElse(() => "User $username created!")
                      .toString()),
                  actions: [
                    CupertinoButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pop(context, [username, password1]);
                      },
                      child: const Text("Back to login"),
                    ),
                  ],
                ),
              );
            } else {
              showCupertinoDialog(
                context: context,
                builder: (BuildContext context) => quickAlertDialog(
                    context,
                    "Signup Failed",
                    signupResult.getOrElse(() => "").toString(),
                    "Dismiss"),
              );
            }
          }
        },
      );

  Widget _cancelButton(BuildContext context) => CupertinoButton(
      child: const Text("Cancel"), onPressed: () => Navigator.pop(context));

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: Center(
        child: ListView(
          shrinkWrap: true,
          children: [
            authenticationTextField("Username", _usernameController),
            authenticationTextField(
              "Password",
              _passwordController,
              obsecureText: true,
            ),
            authenticationTextField(
              "Confirm password",
              _confirmPasswordController,
              obsecureText: true,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _cancelButton(context),
                  Container(
                    width: 20,
                  ),
                  _submitButton(context)
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
