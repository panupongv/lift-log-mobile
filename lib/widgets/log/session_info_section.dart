import 'package:flutter/cupertino.dart';
import 'package:liftlogmobile/models/session.dart';
import 'package:liftlogmobile/utils/styles.dart';
import 'package:liftlogmobile/utils/text_utils.dart';

Widget sessionInfoSection(BuildContext context, Session session,
    {bool showSessionName = false}) {
  EdgeInsets iconInsets =
      const EdgeInsets.only(left: 10, right: 5, top: 5, bottom: 5);
  const double iconSize = 32;

  return Container(
    color: Styles.sessionInfoBackground(context),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: (showSessionName
              ? <Widget>[
                  Row(
                    children: [
                      Padding(
                        padding: iconInsets,
                        child: Text(
                          session.name,
                          style: Styles.sessionPageInfoBold(context),
                        ),
                      ),
                    ],
                  ),
                ]
              : <Widget>[]) +
          [
            Row(
              children: [
                Padding(
                  padding: iconInsets,
                  child: Icon(
                    CupertinoIcons.calendar,
                    color: Styles.iconGrey(context),
                    size: iconSize,
                  ),
                ),
                Text(
                  "${session.getDateInDisplayFormat()} (${session.getDayOfWeek()})",
                  style: Styles.sessionPageInfo(context),
                ),
              ],
            ),
            Row(
              children: [
                Padding(
                  padding: iconInsets,
                  child: Icon(
                    CupertinoIcons.location,
                    color: Styles.iconGrey(context),
                    size: iconSize,
                  ),
                ),
                Text(
                  TextUtils.trimOverflow(session.location, 30),
                  style: Styles.sessionPageInfo(context),
                ),
              ],
            ),
          ],
    ),
  );
}
