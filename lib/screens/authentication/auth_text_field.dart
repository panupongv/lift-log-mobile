import 'package:flutter/material.dart';

//class AuthTextField extends StatelessWidget {
//  AuthTextField()

//  @override
//  Widget build(BuildContext context) {
//    throw UnimplementedError();
//  }

//}

Widget getAuthField(
    String placeholder, TextEditingController textEditingController,
    {TextInputType inputType = TextInputType.text, bool obsecureText = false}) {
  return Padding(
    padding: const EdgeInsets.all(5),
    child: TextField(
      controller: textEditingController,
      keyboardType: inputType,
      obscureText: obsecureText,
      decoration: InputDecoration(hintText: placeholder),
    ),
  );
}
