import 'package:dartz/dartz.dart' as dartz;
import 'package:flutter/material.dart';
import 'package:liftlogmobile/models/user.dart';
import 'package:liftlogmobile/screens/authentication/signup_screen.dart';
import 'package:liftlogmobile/services/data_service.dart';

import 'auth_text_field.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ListView(
          shrinkWrap: true,
          children: [
            getAuthField(
              "Username",
              _usernameController,
            ),
            getAuthField(
              "Password",
              _passwordController,
              obsecureText: true,
            ),
            TextButton(
              child: Text("Go"),
              onPressed: () async {
                dartz.Either<User, String> loginResult =
                    await DataService.login(
                        _usernameController.text, _passwordController.text);
                if (loginResult.isLeft()) {
                  print(loginResult);
                } else {
                  print("Right");
                  print(loginResult);
                }
              },
            ),
            TextButton(
              child: Text("No account? Sign up here"),
              onPressed: () async {
                MaterialPageRoute signupPageRoute =
                    MaterialPageRoute(builder: (context) => SignUpScreen());
                String message = await Navigator.push(
                  context,
                  signupPageRoute,
                );
                print("message from SIgnup Screen: $message");
              },
            )
          ],
        ),
      ),
    );
  }
}
