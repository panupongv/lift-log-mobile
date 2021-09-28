import 'package:dartz/dartz.dart' as dartz;
import 'package:flutter/material.dart';
import 'package:liftlogmobile/models/user.dart';
import 'package:liftlogmobile/services/data_service.dart';

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
      body: ListView(
        children: [
          TextField(
            controller: _usernameController,
            keyboardType: TextInputType.text,
          ),
          TextField(
            controller: _passwordController,
            obscureText: true,
          ),
          TextButton(
            child: Text("Go"),
            onPressed: () async {
              dartz.Either<User, String> loginResult = await DataService.login(
                  _usernameController.text, _passwordController.text);
              if (loginResult.isLeft()) {
                print(loginResult);
              } else {
                print("Right");
                print(loginResult);
              }
            },
          )
        ],
      ),
    );
  }
}
