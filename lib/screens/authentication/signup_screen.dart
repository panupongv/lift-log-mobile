import 'package:flutter/material.dart';
import 'package:liftlogmobile/screens/authentication/auth_text_field.dart';

class SignUpScreen extends StatefulWidget {
  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController _usernameController = TextEditingController(),
      _passwordController = TextEditingController(),
      _confirmPasswordController = TextEditingController();

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
          TextButton(
            onPressed: () {
              Navigator.pop(context, "WAS AT SIGNUP");
            },
            child: Text("Back"),
          )
        ],
      ),
    ));
  }
}
