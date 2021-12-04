import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:liftlogmobile/models/exercise.dart';
import 'package:liftlogmobile/models/session.dart';
import 'package:liftlogmobile/widgets/log/session_edit_screen.dart';
import 'package:liftlogmobile/services/api_service.dart';
import 'package:liftlogmobile/utils/styles.dart';
import 'package:liftlogmobile/widgets/log/session_screen.dart';
import 'package:liftlogmobile/widgets/shared/navigation_bar_text.dart';
import 'package:liftlogmobile/widgets/log/session_list_item.dart';

class LogTab extends StatefulWidget {
  Map<String, Exercise> _exerciseMap;

  LogTab(this._exerciseMap);

  @override
  State<LogTab> createState() => _LogTabState();
}

class _LogTabState extends State<LogTab> {
  int _offset = 0;
  final int _pageSizeIncrement = 5;

  bool _loading = false;
  List<Session> _sessions = [];

  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    _loadSessions();
  }

  Future<void> _loadSessions({bool reset = false}) async {
    setState(() {
      _loading = true;
    });

    if (reset) {
      _offset = 0;
    }

    List<Session> loadedSessions =
        await APIService.getSessions(_offset, _pageSizeIncrement);

    _offset += loadedSessions.length;

    setState(() {
      if (reset) {
        _sessions = loadedSessions;
      } else {
        _sessions += loadedSessions;
      }
    });

    setState(() {
      _loading = false;
    });

    if (reset) {
      _scrollController.jumpTo(0);
    }
  }

  Widget _newSessionButton() {
    return navigationBarTextButton(
      context,
      "New Session",
      () async {
        CupertinoPageRoute sessionEditRoute = CupertinoPageRoute(
            builder: (buildContext) => SessionEditScreen(null));
        dynamic createdSession =
            await Navigator.push(context, sessionEditRoute);
        if (createdSession != null && createdSession is Session) {
          _loadSessions(reset: true);
        }
      },
    );
  }

  Widget _loadMoreButton() {
    return Container(
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.only(top: 15, bottom: 15),
        child: _loading
            ? const CupertinoActivityIndicator()
            : GestureDetector(
                child: Container(
                  decoration: BoxDecoration(
                    color: Styles.listItemBackground(context),
                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                  ),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 6, horizontal: 15),
                    child: Text(
                      "Load More",
                      style: Styles.loadMoreButton(context),
                    ),
                  ),
                ),
                onTap: () async {
                  await _loadSessions();
                  await Future.delayed(const Duration(milliseconds: 200));
                  _scrollController.animateTo(
                    _scrollController.position.maxScrollExtent,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.fastOutSlowIn,
                  );
                },
              ),
      ),
    );
  }

  void _navigateIndividualSession(Session session) {
    CupertinoPageRoute sessionPageRoute = CupertinoPageRoute(
        builder: (buildContext) => SessionScreen(session, widget._exerciseMap));
    Navigator.push(context, sessionPageRoute);
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        automaticallyImplyLeading: false,
        middle: navigationBarTitle(context, "Log"),
        trailing: _newSessionButton(),
      ),
      child: SafeArea(
        top: true,
        child: Container(
          color: Styles.defaultBackground(context),
          child: ListView(
            controller: _scrollController,
            children: <Widget>[] +
                _sessions
                    .map((Session session) =>
                        SessionListItem(session, _loadSessions, _navigateIndividualSession))
                    .toList() +
                <Widget>[_loadMoreButton()],
          ),
        ),
      ),
    );
  }
}
