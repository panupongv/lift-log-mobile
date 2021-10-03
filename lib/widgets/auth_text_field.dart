import 'package:flutter/cupertino.dart';

Widget authenticationTextField(
    String placeholder, TextEditingController textEditingController,
    {TextInputType inputType = TextInputType.text, bool obsecureText = false}) {
  return Padding(
    padding: const EdgeInsets.all(5),
    child: CupertinoTextField(
      controller: textEditingController,
      keyboardType: inputType,
      obscureText: obsecureText,
      placeholder: placeholder,
    ),
  );
}
