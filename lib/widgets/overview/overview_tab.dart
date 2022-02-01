import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:liftlogmobile/models/session.dart';
import 'package:liftlogmobile/models/calendar_session_source.dart';
import 'package:liftlogmobile/services/api_service.dart';
import 'package:liftlogmobile/utils/date_util.dart';
import 'package:liftlogmobile/utils/styles.dart';
import 'package:liftlogmobile/widgets/shared/navigation_bar_text.dart';
import 'package:liftlogmobile/widgets/log/session_list_item.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class OverviewTab extends StatefulWidget {
  @override
  State<OverviewTab> createState() => _OverviewTabState();
}

class _OverviewTabState extends State<OverviewTab> {
  List<Session> _sessions = [];
  List<Session> _sessionsToDisplay = [];
  late DateTime _startDate = _firstDayOfMonth(DateTime.now());
  late DateTime _endDate = _lastDayOfMonth(_startDate);

  CalendarController _calendarController = CalendarController();
  late CalendarSessionSource _calendarDataSource = CalendarSessionSource([]);

  @override
  void initState() {
    _calendarController.selectedDate = today();
    _loadCalendarSessions();
  }

  void _loadCalendarSessions() async {
    _sessions = await APIService.getSessionsByDate(_startDate, _endDate);
    setState(() {
      _calendarDataSource =
          CalendarSessionSource.wrapInSource(context, _sessions);
    });
    _filterSessionsToDisplay();
  }

  DateTime _firstDayOfMonth(DateTime startDate) =>
      startDate.subtract(Duration(days: startDate.day - 1));

  DateTime _lastDayOfMonth(DateTime startDate) =>
      DateUtils.addMonthsToMonthDate(startDate, 1)
          .subtract(const Duration(days: 1));

  void _filterSessionsToDisplay() {
    print(_sessions);
    print(_calendarController.selectedDate!);

    setState(() {
      _sessionsToDisplay = _sessions
          .where((session) =>
              session.date.isAtSameMomentAs(_calendarController.selectedDate!))
          .toList();
    });
    print(_sessionsToDisplay);
  }

  Widget _calendarSection() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Styles.listItemBackground(context),
          borderRadius: const BorderRadius.all(Radius.circular(8)),
        ),
        height: 300,
        child: SfCalendar(
          controller: _calendarController,
          headerStyle:
              CalendarHeaderStyle(textStyle: Styles.calendarHeader(context)),
          viewHeaderStyle: ViewHeaderStyle(
            dayTextStyle: Styles.calendarDayLabel(context),
          ),
          monthViewSettings: MonthViewSettings(
              monthCellStyle:
                  MonthCellStyle(textStyle: Styles.calendarNormalDay(context))),
          todayTextStyle: Styles.calendarToday(context),
          minDate: _startDate,
          maxDate: _endDate,
          view: CalendarView.month,
          dataSource: _calendarDataSource,
          onSelectionChanged: (CalendarSelectionDetails details) {
            Future.delayed(Duration.zero, () async {
              _filterSessionsToDisplay();
            });
          },
        ),
      ),
    );
  }

  Widget _todayButton() {
    return GestureDetector(
      child: Text("Today", style: Styles.monthShiftButton(context)),
      onTap: () {
        setState(() {
          DateTime todaysDate = today();
          _calendarController.selectedDate = todaysDate;
          _startDate = _firstDayOfMonth(todaysDate);
          _endDate = _lastDayOfMonth(_startDate);
        });
        _loadCalendarSessions();
      },
    );
  }

  Widget _monthShiftButton(bool next) {
    return GestureDetector(
      child: (next
          ? Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text("Next", style: Styles.monthShiftButton(context)),
                Icon(CupertinoIcons.right_chevron,
                    color: Styles.activeColor(context)),
                Container(
                  width: 10,
                )
              ],
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  width: 10,
                ),
                Icon(CupertinoIcons.left_chevron,
                    color: Styles.activeColor(context)),
                Text("Previous", style: Styles.monthShiftButton(context)),
              ],
            )),
      onTap: () async {
        setState(() {
          _startDate =
              DateUtils.addMonthsToMonthDate(_startDate, next ? 1 : -1);
          _endDate = _lastDayOfMonth(_startDate);
        });
        _sessions = await APIService.getSessionsByDate(_startDate, _endDate);
        _loadCalendarSessions();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: navigationBarTitle(context, "Overview"),
        trailing: navigationBarTextButton(context, "Refresh", () {
          _loadCalendarSessions();
        }),
      ),
      backgroundColor: Styles.defaultBackground(context),
      child: SafeArea(
        top: true,
        child: ListView(
          children: [
                _calendarSection(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      child: _monthShiftButton(false),
                      width: 120,
                    ),
                    Align(
                      child: _todayButton(),
                      alignment: Alignment.center,
                    ),
                    SizedBox(
                      child: _monthShiftButton(true),
                      width: 120,
                    )
                  ],
                ),
              ] +
              _sessionsToDisplay
                  .map((e) => SessionListItem(e, () {}, () {}))
                  .toList(),
        ),
      ),
    );
  }
}
