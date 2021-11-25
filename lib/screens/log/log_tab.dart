import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:liftlogmobile/lift_log_app.dart';
import 'package:liftlogmobile/models/exercise.dart';
import 'package:liftlogmobile/models/session.dart';
import 'package:liftlogmobile/models/user.dart';
import 'package:liftlogmobile/screens/auth/login_screen.dart';
import 'package:liftlogmobile/screens/log/session_edit_screen.dart';
import 'package:liftlogmobile/services/api_service.dart';
import 'package:liftlogmobile/services/local_storage_service.dart';
import 'package:liftlogmobile/screens/exercise_library/add_exercise_item.dart';
import 'package:liftlogmobile/screens/exercise_library/exercise_list_item.dart';
import 'package:liftlogmobile/widgets/navigation_bar_text.dart';
import 'package:liftlogmobile/screens/log/session_list_item.dart';

class LogTab extends StatefulWidget {
  LogTab();

  @override
  State<LogTab> createState() => _LogTabState();
}

class _LogTabState extends State<LogTab> {
  int _offset = 0;
  final int _pageSizeIncrement = 4;

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
        List<Session> concatenated = _sessions + loadedSessions;
        _sessions = concatenated;
      }
    });

    setState(() {
      _loading = false;
    });

    if (reset) {
      _scrollController.jumpTo(0);
    }
  }

  Widget _loadMoreButton() {
    return Container(
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: _loading
            ? CupertinoActivityIndicator()
            : GestureDetector(
                child: Text("Load More"),
                onTap: () async {
                  await _loadSessions();
                  await Future.delayed(Duration(milliseconds: 200));
                  _scrollController.animateTo(
                    _scrollController.position.maxScrollExtent,
                    duration: Duration(milliseconds: 300),
                    curve: Curves.fastOutSlowIn,
                  );
                },
              ),
      ),
    );
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
        child: ListView(
          controller: _scrollController,
          children: <Widget>[] +
              _sessions
                  .map((Session session) =>
                      SessionListItem(session, _loadSessions))
                  .toList() +
              <Widget>[_loadMoreButton()],
        ),
      ),
    );
  }
}
