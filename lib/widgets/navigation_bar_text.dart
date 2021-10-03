import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//import 'package:instagrow/utils/style.dart';

Widget navigationBarTitle(BuildContext context, String title) {
  return Text(
    title,
    //style: Styles.navigationBarTitle(context),
  );
}

Widget navigationBarTextButton(
    BuildContext context, String text, Function onTapCallback) {
  return GestureDetector(
    child: Text(
      text,
      //style: Styles.navigationBarTextActive(context),
    ),
    onTap: () {
      onTapCallback();
    },
  );
}
