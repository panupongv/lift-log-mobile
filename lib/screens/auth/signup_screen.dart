import 'package:dartz/dartz.dart' as dz;
import 'package:flutter/cupertino.dart';
import 'package:liftlogmobile/utils/styles.dart';
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

  bool _buttonAvailable = true;

  void _submitSignup() async {
    setState(() {
      _buttonAvailable = false;
    });
    String username = _usernameController.text;
    String password1 = _passwordController.text;
    String password2 = _confirmPasswordController.text;
    String? errorMessage;

    if (AuthFieldValidator.hasEmptyField([username, password1, password2])) {
      errorMessage = "Please fill in all the fields.";
    } else if (AuthFieldValidator.passwordTooShort(password1)) {
      errorMessage = "Password too short.";
    } else if (AuthFieldValidator.passwordMismatch(password1, password2)) {
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
            title: const Text("Signup successful"),
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
    setState(() {
      _buttonAvailable = true;
    });
  }

  Widget _submitButton(BuildContext context) => UnconstrainedBox(
        child: CupertinoButton.filled(
          disabledColor: Styles.disabledAuthButton(),
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          child: _buttonAvailable? const Text("Submit"):const Text("Processing"),
          onPressed: _buttonAvailable? _submitSignup:null,
        ),
      );

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text("Lift Log"),
      ),
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
            Container(
              height: 20,
            ),
            _submitButton(context)
          ],
        ),
      ),
    );
  }
}
