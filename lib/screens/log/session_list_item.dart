import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:liftlogmobile/models/session.dart';
import 'package:liftlogmobile/screens/log/session_edit_screen.dart';
import 'package:liftlogmobile/services/api_service.dart';

class SessionListItem extends StatefulWidget {
  Session _session;
  Function _reloadSessions;

  SessionListItem(this._session, this._reloadSessions);

  @override
  State<SessionListItem> createState() => _SessionListItemState();
}

class _SessionListItemState extends State<SessionListItem> {
  Widget _deleteSessionDialog(
      BuildContext context, Session session, Function _reloadSessions) {
    return CupertinoAlertDialog(
      title: Text("Delete Session"),
      content: Text("Are you sure?"),
      actions: [
        CupertinoDialogAction(
          child: Text("Cancel"),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        CupertinoDialogAction(
          child: Text("Delete"),
          onPressed: () async {
            bool deleted = await APIService.deleteSession(widget._session);
            if (deleted) {
              _reloadSessions(reset: true);
              Navigator.pop(context);
              Navigator.pop(context);
            }
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.greenAccent),
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 10, top: 10, bottom: 10),
                  child: Text(widget._session.name),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10, top: 10, bottom: 10),
                  child: Text(widget._session.getDateInDisplayFormat()),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10, top: 10, bottom: 10),
                  child: Text(widget._session.location),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(right: 10, top: 10, bottom: 10),
              child: GestureDetector(
                child: Icon(CupertinoIcons.ellipsis),
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
                          child: Text(
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
