import 'dart:math';

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
import 'package:sprintf/sprintf.dart';

class WorkoutHistoryScreen extends StatefulWidget {
  final Session _baseSession;
  final Workout _baseWorkout;
  final Exercise _exercise;

  WorkoutHistoryScreen(this._baseSession, this._baseWorkout, this._exercise);

  @override
  State<WorkoutHistoryScreen> createState() =>
      _WorkoutHistoryScreenState(_baseSession);
}

class _WorkoutHistoryScreenState extends State<WorkoutHistoryScreen> {
  int _offset = 0;
  bool _loading = false;

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
    setState(() {
      _loading = true;
    });

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
    setState(() {
      _loading = false;
    });
  }

  Widget _copyButton() {
    return navigationBarTextButton(context, "Copy", () {
      Navigator.pop(context, _workout.content);
    });
  }

  Widget _contentRowHalf(String setString) {
    bool showContent = false;
    String weightString = "";
    String repsString = "";

    List<String> weightAndReps = setString.split(Workout.weightRepsSeparator);
    if (weightAndReps.length == 2) {
      showContent = true;
      weightString = weightAndReps[0];
      repsString = weightAndReps[1];
    }

    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: Styles.listItemBackground(context),
          borderRadius: const BorderRadius.all(
            Radius.circular(8.0),
          ),
        ),
        child: Align(
          alignment: Alignment.bottomRight,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Text(
              showContent ? sprintf("%s kg x %2s", [weightString, repsString]) : "",
              style: Styles.historyContentRow(context),
            ),
          ),
        ),
      ),
    );
  }

  Widget _contentDisplayRow(String baseSetString, String setString) {
    //List<String> weightAndReps = setString!.split(Workout.weightRepsSeparator);
    //String weightString = "";
    //String repsString = "";
    //if (weightAndReps.length == 2) {
    //  weightString = "${weightAndReps[0]} kg";
    //  repsString = "${weightAndReps[1]} reps";
    //}
    //return Container();
    return Padding(
      padding: const EdgeInsets.only(top: 12, left: 8, right: 8),
      child: Row(
        children: [
          _contentRowHalf(baseSetString),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 4),
            child: Icon(CupertinoIcons.arrow_left),
          ),
          _contentRowHalf(setString)
        ],
      ),
    );
  }

  Widget _contentDisplay() {
    List<String> baseContent =
        widget._baseWorkout.content.split(Workout.setSeparator);
    List<String> currentContent = _workout.content.split(Workout.setSeparator);
    int numberOfRows = max(baseContent.length, currentContent.length);

    return ListView(
        children: List<int>.generate(numberOfRows, (i) => i)
            .map((index) => _contentDisplayRow(
                index >= baseContent.length ? "" : baseContent[index],
                index >= currentContent.length ? "" : currentContent[index]))
            .toList());

    //int sets = _workout.sets;
    //String setHeaderString = "$sets set${sets == 1 ? '' : 's'}";

    //return Padding(
    //    padding: const EdgeInsets.only(
    //      top: 8,
    //      left: 8,
    //      right: 8,
    //      bottom: 4,
    //    ),
    //    child: Container(
    //      decoration: BoxDecoration(
    //        color: Styles.listItemBackground(context),
    //        borderRadius: const BorderRadius.all(Radius.circular(8)),
    //      ),
    //      child: ListView(
    //        children: <Widget>[
    //              Padding(
    //                padding:
    //                    const EdgeInsets.only(top: 8, left: 12, bottom: 12),
    //                child: Text(
    //                  setHeaderString,
    //                  style: Styles.historySetHeader(context),
    //                ),
    //              ),
    //            ] +
    //            _workout.content
    //                .split(Workout.setSeparator)
    //                .map((setString) => _contentDisplayRow(setString))
    //                .toList(),
    //      ),
    //    ));
  }

  Widget _sessionShiftButton(bool next) {
    bool available =
        (next && _nextSession != null) || (!next && _previousSession != null);

    Session targetSession = available
        ? (next ? _nextSession! : _previousSession!)
        : Session("", "", DateTime.now(), "");
    EdgeInsets boxInsets = next
        ? const EdgeInsets.only(top: 8, left: 8, right: 4, bottom: 8)
        : const EdgeInsets.only(top: 8, left: 4, right: 8, bottom: 8);
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
                              style: Styles.historyShiftButton(
                                  context, available)),
                        ],
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text("Previous Session",
                              style: Styles.historyShiftButton(
                                  context, available)),
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
                  child: Text(
                      available ? targetSession.getDateInDisplayFormat() : "",
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
          if (!available || _loading) return;
          if (next) {
            _offset -= 1;
          } else {
            _offset += 1;
          }
          _fetchHistory(_offset);
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
        child: Column(
          children: [
                sessionInfoSection(
                  context,
                  _session,
                  showSessionName: true,
                )
              ] +
              [
                Expanded(
                  child: _loading
                      ? const Center(child: CupertinoActivityIndicator())
                      : _contentDisplay(),
                )
              ] +
              [
                Container(
                  color: Styles.defaultBackground(context),
                  child: Row(
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
                ),
              ],
        ),
      ),
    );
  }
}
