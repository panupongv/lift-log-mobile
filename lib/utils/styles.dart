import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

abstract class Styles {
  // Colors
  static Color _dynamicColor(
          BuildContext context, Color normalColor, Color darkModeColor) =>
      CupertinoTheme.brightnessOf(context) == Brightness.dark
          ? darkModeColor
          : normalColor;

  static Color _defaultText(context) =>
      _dynamicColor(context, CupertinoColors.black, CupertinoColors.white);

  static Color _dynamicGrey(context) => _dynamicColor(
        context,
        CupertinoColors.inactiveGray.color,
        CupertinoColors.inactiveGray.darkColor,
      );

  static Color activeColor(context) => _dynamicColor(context,
      CupertinoColors.activeBlue.color, CupertinoColors.activeBlue.darkColor);
  static Color inactiveColor(context) => _dynamicGrey(context);

  static Color cautiousActionColor(context) => _dynamicColor(context,
      CupertinoColors.systemRed.color, CupertinoColors.systemRed.darkColor);

  static Color iconGrey(context) => _dynamicGrey(context);

  static Color disabledAuthButton(context) => _dynamicGrey(context);

  static Color defaultBackground(context) => _dynamicColor(context,
      CupertinoColors.lightBackgroundGray, CupertinoColors.darkBackgroundGray);

  static Color listItemBackground(context) =>
      _dynamicColor(context, CupertinoColors.white, CupertinoColors.black);

  static Color ellipsisIcon(context) => _dynamicGrey(context);

  static Color datePicker(context) =>
      _dynamicColor(context, CupertinoColors.white, CupertinoColors.black);

  static Color sessionInfoBackground(context) =>
      _dynamicColor(context, CupertinoColors.white, CupertinoColors.black);

  static Color exercisePickerBackground(context) =>
      _dynamicColor(context, CupertinoColors.white, CupertinoColors.black);

  // TextStyles

  static const String _defaultFontFamily = 'SFPro';

  static TextStyle dialogTitle(context) {
    return TextStyle(
      fontFamily: _defaultFontFamily,
      color: _defaultText(context),
      fontWeight: FontWeight.w600,
      fontSize: 17,
    );
  }

  static TextStyle dialogContent(context) {
    return TextStyle(
      fontFamily: _defaultFontFamily,
      color: _defaultText(context),
      fontSize: 13,
    );
  }

  static TextStyle dialogActionNormal(context) {
    return TextStyle(
      fontFamily: _defaultFontFamily,
      color: activeColor(context),
      fontSize: 17,
    );
  }

  static TextStyle dialogActionCrucial(context) {
    return TextStyle(
      fontFamily: _defaultFontFamily,
      color: cautiousActionColor(context),
      fontSize: 17,
    );
  }

  static TextStyle navigationBarTitle(context) => TextStyle(
        fontFamily: _defaultFontFamily,
        fontSize: 17,
        color: _defaultText(context),
      );

  static TextStyle navigationBarText(context, {isActive = true}) => TextStyle(
        fontFamily: _defaultFontFamily,
        color: isActive ? activeColor(context) : inactiveColor(context),
        fontSize: 17,
      );

  static TextStyle cautiousDialogAction(context, isActive) => TextStyle(
      color: isActive ? cautiousActionColor(context) : _dynamicGrey(context));

  // Log Tab TextStyles

  static TextStyle sessionListItemHeader(context) => TextStyle(
      fontFamily: _defaultFontFamily,
      fontSize: 17,
      fontWeight: FontWeight.bold,
      color: _defaultText(context));

  static TextStyle sessionListItemDetails(context) => TextStyle(
      fontFamily: _defaultFontFamily,
      fontSize: 14,
      color: _dynamicGrey(context));

  static TextStyle loadMoreButton(context) => TextStyle(
      fontFamily: _defaultFontFamily,
      fontSize: 17,
      color: _defaultText(context));

  // Session Edit Screen TextStyles

  static TextStyle editSessionLabels(context) => TextStyle(
      fontFamily: _defaultFontFamily,
      fontSize: 17,
      color: _defaultText(context));

  // Session Screen TextStyles

  static TextStyle sessionPageInfoBold(context) => TextStyle(
      fontWeight: FontWeight.bold,
      fontFamily: _defaultFontFamily,
      fontSize: 17,
      color: _defaultText(context));

  static TextStyle sessionPageInfo(context) => TextStyle(
      fontFamily: _defaultFontFamily,
      fontSize: 17,
      color: _defaultText(context));

  static TextStyle workoutListItemHeader(context) => TextStyle(
      fontFamily: _defaultFontFamily,
      fontSize: 17,
      fontWeight: FontWeight.bold,
      color: _defaultText(context));

  static TextStyle workoutListItemDetails(context) => TextStyle(
      fontFamily: _defaultFontFamily,
      fontSize: 14,
      color: _dynamicGrey(context));

  // Workout Screen TextStyles

  static TextStyle workoutScreenLabels(context) => TextStyle(
      fontFamily: _defaultFontFamily,
      fontSize: 17,
      color: _defaultText(context));

  static TextStyle exercisePicker(context) => TextStyle(
      fontFamily: _defaultFontFamily,
      fontSize: 21,
      color: _defaultText(context));

  static TextStyle historyButton(context, isActive) => TextStyle(
      fontFamily: _defaultFontFamily,
      fontSize: 17,
      color: isActive ? activeColor(context) : inactiveColor(context));

  static TextStyle contentRowLabel(context) => TextStyle(
      fontFamily: _defaultFontFamily,
      fontSize: 17,
      color: _defaultText(context));

  static TextStyle addSetButton(context) => TextStyle(
      fontFamily: _defaultFontFamily,
      fontSize: 17,
      color: _defaultText(context));

  static TextStyle historyShiftButton(context) => TextStyle(
      fontFamily: _defaultFontFamily,
      fontSize: 15,
      color: activeColor(context));

  static TextStyle historyShiftInfo(context) => TextStyle(
      fontFamily: _defaultFontFamily,
      fontSize: 15,
      color: _defaultText(context));

  // Exercise Tab TextStyles

  static TextStyle exerciseItemHeader(context) => TextStyle(
      fontFamily: _defaultFontFamily,
      fontSize: 17,
      fontWeight: FontWeight.bold,
      color: _defaultText(context));

  static TextStyle addExercise(context) => TextStyle(
      fontFamily: _defaultFontFamily,
      fontSize: 17,
      color: _defaultText(context));
}
