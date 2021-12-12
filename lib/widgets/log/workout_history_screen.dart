import 'package:flutter/cupertino.dart';
import 'package:liftlogmobile/utils/styles.dart';
import 'package:liftlogmobile/widgets/shared/navigation_bar_text.dart';

class WorkoutHistoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: Styles.defaultBackground(context),
      navigationBar: CupertinoNavigationBar(
        middle: navigationBarTitle(context, "History"),
      ),
      child: SafeArea(
        top: true,
        child: Container()
      ),
    );
  }

}