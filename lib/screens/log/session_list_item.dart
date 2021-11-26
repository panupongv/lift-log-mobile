import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:liftlogmobile/models/session.dart';
import 'package:liftlogmobile/screens/log/session_edit_screen.dart';
import 'package:liftlogmobile/services/api_service.dart';
import 'package:liftlogmobile/utils/styles.dart';

class SessionListItem extends StatefulWidget {
  final Session _session;
  final Function _reloadSessions;

  SessionListItem(this._session, this._reloadSessions);

  @override
  State<SessionListItem> createState() => _SessionListItemState();
}

class _SessionListItemState extends State<SessionListItem> {
  Widget _deleteSessionDialog(
      BuildContext context, Session session, Function _reloadSessions) {

    bool deleting = false;

    return CupertinoAlertDialog(
      title: const Text("Delete Session"),
      content: const Text("Are you sure?"),
      actions: [
        CupertinoDialogAction(
          child: const Text("Cancel"),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        CupertinoDialogAction(
          child: Text("Delete", style: Styles.cautiousDialogAction(context, !deleting)),
          onPressed: () async {
            if (!deleting) {
              setState(() {
                deleting = true;  
              });
              bool deleted = await APIService.deleteSession(widget._session);
              if (deleted) {
                _reloadSessions(reset: true);
                Navigator.pop(context);
                Navigator.pop(context);
              }
              setState(() {
                deleting = false;  
              });
            }
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15, left: 15, right: 15),
      child: Container(
        decoration: BoxDecoration(
          color: Styles.listItemBackground(context),
          borderRadius: const BorderRadius.all(Radius.circular(8)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 15, top: 10, bottom: 5),
                  child: Text(widget._session.name,
                      style: Styles.sessionListItemHeader(context)),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15, bottom: 10),
                  child: Row(
                    children: [
                          Icon(CupertinoIcons.calendar,
                              color: Styles.iconGrey(context)),
                          Container(width: 5),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget._session.getDayOfWeek(),
                                style: Styles.sessionListItemDetails(context),
                              ),
                              Text(
                                widget._session.getDateInDisplayFormat(),
                                style: Styles.sessionListItemDetails(context),
                              ),
                            ],
                          ),
                          Container(width: 15),
                        ] +
                        (widget._session.location != ""
                            ? [
                                Icon(CupertinoIcons.location,
                                    color: Styles.iconGrey(context)),
                                Container(width: 5),
                                Text(
                                  widget._session.location,
                                  style: Styles.sessionListItemDetails(context),
                                ),
                              ]
                            : []),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(right: 10, top: 10, bottom: 10),
              child: GestureDetector(
                child: Icon(CupertinoIcons.ellipsis, color: Styles.ellipsisIcon(context),),
                onTap: () async {
                  await showCupertinoModalPopup(
                    context: context,
                    builder: (BuildContext buildContext) {
                      return CupertinoActionSheet(
                        actions: [
                          CupertinoActionSheetAction(
                            onPressed: () async {
                              Navigator.pop(buildContext);
                              CupertinoPageRoute sessionEditRoute =
                                  CupertinoPageRoute(
                                      builder: (buildContext) =>
                                          SessionEditScreen(widget._session));
                              dynamic updatedSession = await Navigator.push(
                                  context, sessionEditRoute);
                              if (updatedSession != null &&
                                  updatedSession is Session) {
                                widget._reloadSessions(reset: true);
                              }
                            },
                            child: const Text("Edit"),
                          ),
                          CupertinoActionSheetAction(
                            onPressed: () {
                              showCupertinoDialog(
                                context: context,
                                builder: (BuildContext buildContext) {
                                  return _deleteSessionDialog(
                                    buildContext,
                                    widget._session,
                                    widget._reloadSessions,
                                  );
                                },
                              );
                            },
                            child: const Text("Delete"),
                          ),
                        ],
                        cancelButton: CupertinoActionSheetAction(
                          child: const Text(
                            "Cancel",
                          ),
                          onPressed: () {
                            Navigator.of(buildContext).pop();
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
