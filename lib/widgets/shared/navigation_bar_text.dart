import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:liftlogmobile/utils/styles.dart';

Widget navigationBarTitle(BuildContext context, String title) {
  return Text(
    title,
    style: Styles.navigationBarTitle(context),
  );
}

Widget navigationBarTextButton(
    BuildContext context, String text, Function onTapCallback,
    {bool isActive = true}) {
  return GestureDetector(
    child: Text(
      text,
      style: Styles.navigationBarText(context, isActive: isActive),
    ),
    onTap: () {
      if (isActive) {
        onTapCallback();
      }
    },
  );
}
