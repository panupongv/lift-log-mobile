import 'package:flutter/cupertino.dart';
import 'package:liftlogmobile/models/exercise.dart';
import 'package:liftlogmobile/models/session.dart';
import 'package:liftlogmobile/utils/styles.dart';
import 'package:liftlogmobile/widgets/shared/navigation_bar_text.dart';

class SessionScreen extends StatelessWidget {
  final Session _session;
  final Map<String, Exercise> _exerciseMap;

  SessionScreen(this._session, this._exerciseMap);

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
          middle: navigationBarTitle(context, _session.name)),
      child: SafeArea(
        top: true,
        child: Container(
          color: Styles.defaultBackground(context),
          child: ListView(
              children: _exerciseMap.values
                  .map((e) => Text(
                        e.name,
                        style: Styles.dialogTitle(context),
                      ))
                  .toList()),
        ),
      ),
    );
  }
}
