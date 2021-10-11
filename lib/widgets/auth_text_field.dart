import 'package:flutter/cupertino.dart';

Widget authenticationTextField(
    String placeholder, TextEditingController textEditingController,
    {TextInputType inputType = TextInputType.text, bool obsecureText = false}) {
  return Container(
    margin: EdgeInsets.only(top: 5, bottom: 5),
    child: Padding(
      padding: const EdgeInsets.only(left: 5, right: 5),
      child: CupertinoTextField(
        controller: textEditingController,
        keyboardType: inputType,
        obscureText: obsecureText,
        placeholder: placeholder,
      ),
    ),
  );
}
