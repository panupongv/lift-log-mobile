import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

abstract class Styles {
  // Colors
  static Color _dynamicColor(
      BuildContext context, Color normalColor, Color darkModeColor) {
    return CupertinoTheme.brightnessOf(context) == Brightness.dark
        ? darkModeColor
        : normalColor;
  }

  static Color _defaultText(context) =>
      _dynamicColor(context, CupertinoColors.black, CupertinoColors.white);

  static Color _dynamicGrey(context) => _dynamicColor(
        context,
        CupertinoColors.inactiveGray.color,
        CupertinoColors.inactiveGray.darkColor,
      );

  static Color activeColor(context) => _dynamicColor(context, CupertinoColors.activeBlue.color, CupertinoColors.activeBlue.darkColor);
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

  // TextStyles

  static const String _defaultFontFamily = 'SFPro';

  static TextStyle navigationBarTitle(context) => TextStyle(
        fontFamily: 'SFPro',
        fontSize: 17,
        color: _defaultText(context),
      );

  static TextStyle navigationBarTextActive(context) => TextStyle(
        fontFamily: 'SFPro',
        color: activeColor(context),
        fontSize: 17,
      );

  static TextStyle navigationBarTextInactive(context) => TextStyle(
        fontFamily: 'SFPro',
        color: _dynamicGrey(context),
        fontSize: 17,
      );

  static TextStyle cautiousDialogAction(context, isActive) => TextStyle(
    color: isActive? cautiousActionColor(context) : _dynamicGrey(context)
  );

  static TextStyle sessionListItemHeader(context) => TextStyle(
      fontFamily: _defaultFontFamily,
      fontSize: 17,
      fontWeight: FontWeight.bold,
      color: _defaultText(context));

  static TextStyle sessionListItemDetails(context) => TextStyle(
      fontFamily: _defaultFontFamily,
      fontSize: 14,
      color: _dynamicGrey(context));
}
