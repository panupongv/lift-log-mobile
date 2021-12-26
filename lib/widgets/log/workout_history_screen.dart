import 'package:dartz/dartz.dart' as dz;
import 'package:flutter/cupertino.dart';
import 'package:liftlogmobile/models/exercise.dart';
import 'package:liftlogmobile/models/session.dart';
import 'package:liftlogmobile/models/workout.dart';
import 'package:liftlogmobile/services/api_service.dart';
import 'package:liftlogmobile/utils/styles.dart';
import 'package:liftlogmobile/utils/text_utils.dart';
import 'package:liftlogmobile/widgets/log/session_info_section.dart';
import 'package:liftlogmobile/widgets/shared/navigation_bar_text.dart';

class WorkoutHistoryScreen extends StatefulWidget {
  final Session _baseSession;
  final Exercise _exercise;

  WorkoutHistoryScreen(this._baseSession, this._exercise);

  @override
  State<WorkoutHistoryScreen> createState() =>
      _WorkoutHistoryScreenState(_baseSession);
}

class _WorkoutHistoryScreenState extends State<WorkoutHistoryScreen> {
  int _offset = 0;
  late Session _session;
  Workout _workout = Workout.blankWorkout();
  Session? _nextSession;
  Session? _previousSession;

  _WorkoutHistoryScreenState(this._session);

  @override
  void initState() {
    _fetchHistory(_offset);
  }

  void _fetchHistory(int offset) async {
    dz.Tuple4<Session, Workout, Session?, Session?>? fetchResults =
        await APIService.getHistory(
            widget._baseSession, widget._exercise, offset);

    if (fetchResults != null) {
      setState(() {
        _session = fetchResults.value1;
        _workout = fetchResults.value2;
        _nextSession = fetchResults.value3;
        _previousSession = fetchResults.value4;
      });
    }
  }

  Widget _sessionShiftButton(bool next) {
    bool available =
        (next && _nextSession != null) || (!next && _previousSession != null);

    if (!available) return Container();

    Session targetSession = next ? _nextSession! : _previousSession!;
    EdgeInsets boxInsets = next
        ? const EdgeInsets.only(top: 8, left: 8, right: 4)
        : const EdgeInsets.only(top: 8, left: 4, right: 8);
    EdgeInsets infoInsets = const EdgeInsets.only(left: 4);

    return GestureDetector(
        child: Padding(
          padding: boxInsets,
          child: Container(
            decoration: BoxDecoration(
              color: Styles.listItemBackground(context),
              borderRadius: const BorderRadius.all(Radius.circular(8)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                (next
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(
                            CupertinoIcons.left_chevron,
                            color: available
                                ? Styles.activeColor(context)
                                : Styles.inactiveColor(context),
                          ),
                          Text("Next Session",
                              style: Styles.historyShiftButton(context)),
                        ],
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text("Previous Session",
                              style: Styles.historyShiftButton(context)),
                          Icon(
                            CupertinoIcons.right_chevron,
                            color: available
                                ? Styles.activeColor(context)
                                : Styles.inactiveColor(context),
                          ),
                        ],
                      )),
                Padding(
                  padding: infoInsets,
                  child: Text(TextUtils.trimOverflow(targetSession.name, 24),
                      style: Styles.historyShiftInfo(context)),
                ),
                Padding(
                  padding: infoInsets,
                  child: Text(targetSession.getDateInDisplayFormat(),
                      style: Styles.historyShiftInfo(context)),
                ),
                Container(
                  height: 4,
                )
              ],
            ),
          ),
        ),
        onTap: () {
          if (!available) return;
          if (next) {
            _offset -= 1;
          } else {
            _offset += 1;
          }
          _fetchHistory(_offset);
        });
  }

  Widget _previousButton() {
    bool available = _previousSession != null;

    if (!available) return Container();
    return Padding(
      padding: const EdgeInsets.only(top: 8, left: 4, right: 8),
      child: Container(
        decoration: BoxDecoration(
          color: Styles.listItemBackground(context),
          borderRadius: const BorderRadius.all(Radius.circular(8)),
        ),
        child: GestureDetector(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text("Previous Session",
                      style: Styles.historyShiftButton(context)),
                  Icon(
                    CupertinoIcons.right_chevron,
                    color: available
                        ? Styles.activeColor(context)
                        : Styles.inactiveColor(context),
                  ),
                ],
              ),
              Text(_previousSession!.name,
                  style: Styles.historyShiftButton(context)),
            ],
          ),
          onTap: () {
            if (!available) return;
            _offset += 1;
            _fetchHistory(_offset);
          },
        ),
      ),
    );
  }

  Widget _copyButton() {
    return navigationBarTextButton(context, "Copy", () {
      Navigator.pop(context, _workout.content);
    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: Styles.defaultBackground(context),
      navigationBar: CupertinoNavigationBar(
        middle: navigationBarTitle(context, "History"),
        trailing: _copyButton(),
      ),
      child: SafeArea(
        top: true,
        child: ListView(
          children: [
            sessionInfoSection(
              context,
              _session,
              showSessionName: true,
            ),
            Text(_offset.toString()),
            Text(_session.getDateInDisplayFormat()),
            Text(_workout.content),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: _sessionShiftButton(true),
                  flex: 1,
                ),
                Flexible(
                  child: _sessionShiftButton(false),
                  flex: 1,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
