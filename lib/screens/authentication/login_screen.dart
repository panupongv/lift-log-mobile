import 'package:dartz/dartz.dart' as dz;
import 'package:flutter/material.dart';
import 'package:liftlogmobile/models/user.dart';
import 'package:liftlogmobile/screens/authentication/signup_screen.dart';
import 'package:liftlogmobile/services/api_service.dart';

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
              child: const Text("Go"),
              onPressed: () async {
                dz.Either<User, String> loginResult = await APIService.login(
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
                dynamic usernameAndPassword = await Navigator.push(
                  context,
                  signupPageRoute,
                );
                print(
                    "message from SIgnup Screen: ${usernameAndPassword.toString()}");
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
