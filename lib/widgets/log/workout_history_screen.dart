import 'package:flutter/cupertino.dart';
import 'package:liftlogmobile/models/exercise.dart';
import 'package:liftlogmobile/models/session.dart';
import 'package:liftlogmobile/services/api_service.dart';
import 'package:liftlogmobile/utils/styles.dart';
import 'package:liftlogmobile/widgets/shared/navigation_bar_text.dart';

class WorkoutHistoryScreen extends StatelessWidget {
  Session _session;
  Exercise _exercise;

  WorkoutHistoryScreen(this._session, this._exercise) {
    APIService.getHistory(_session, _exercise, 0);
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: Styles.defaultBackground(context),
      navigationBar: CupertinoNavigationBar(
        middle: navigationBarTitle(context, "History"),
      ),
      child: SafeArea(
        top: true,
        child: Container(),
      ),
    );
  }
}