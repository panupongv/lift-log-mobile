import 'package:dartz/dartz.dart' as dz;
import 'package:flutter/material.dart';
import 'package:liftlogmobile/screens/authentication/auth_text_field.dart';
import 'package:liftlogmobile/services/api_service.dart';
import 'package:liftlogmobile/utils/auth_field_validator.dart';

class SignUpScreen extends StatefulWidget {
  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController _usernameController = TextEditingController(),
      _passwordController = TextEditingController(),
      _confirmPasswordController = TextEditingController();

  Widget _submitButton(BuildContext context) => TextButton(
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
            showDialog(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                content: Text(errorMessage!),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Dismiss"),
                  ),
                ],
              ),
            );
          } else {
            dz.Either<bool, String> signupResult =
                await APIService.signup(username, password1);
            if (signupResult.isLeft()) {
              showDialog(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  content: Text(
                      signupResult.getOrElse(() => "User $username created!").toString()),
                  actions: [
                    TextButton(
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
              showDialog(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  content: Text(
                      signupResult.getOrElse(() => "Signup Failed").toString()),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Dismiss"),
                    ),
                  ],
                ),
              );
            }
          }
        },
      );

  Widget _cancelButton(BuildContext context) => TextButton(
      child: const Text("Cancel"), onPressed: () => Navigator.pop(context));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ListView(
          shrinkWrap: true,
          children: [
            getAuthField("Username", _usernameController),
            getAuthField(
              "Password",
              _passwordController,
              obsecureText: true,
            ),
            getAuthField(
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
