import 'package:flutter/cupertino.dart';
import 'package:liftlogmobile/models/exercise.dart';
import 'package:liftlogmobile/models/session.dart';
import 'package:liftlogmobile/utils/styles.dart';
import 'package:liftlogmobile/widgets/shared/navigation_bar_text.dart';

class SessionScreen extends StatelessWidget {
  final Session _session;
  final Map<String, Exercise> _exerciseMap;

  SessionScreen(this._session, this._exerciseMap);

  Widget _infoSection(context) {
    return Container(
      color: Styles.sessionInfoBackground(context),
      height: 100,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 5),
                child: Icon(CupertinoIcons.calendar,
                    color: Styles.iconGrey(context), size: 32),
              ),
              Text("${_session.getDayOfWeek()},",
                  style: Styles.sessionPageInfo(context)),
              Container(width: 5),
              Text(_session.getDateInDisplayFormat(),
                  style: Styles.sessionPageInfo(context)),
            ],
          ),
          Container(height: 5,),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 5),
                child: Icon(CupertinoIcons.location,
                    color: Styles.iconGrey(context), size: 32),
              ),
              Text(_session.location, style: Styles.sessionPageInfo(context)),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
          middle: navigationBarTitle(context, _session.name)),
      child: SafeArea(
        top: true,
        child: Container(
          color: Styles.defaultBackground(context),
          child: ListView(children: [_infoSection(context)]),
        ),
      ),
    );
  }
}
