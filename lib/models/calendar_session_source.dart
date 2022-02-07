import 'package:flutter/material.dart';
import 'package:liftlogmobile/models/session.dart';
import 'package:liftlogmobile/utils/styles.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';


class CalendarSessionSource extends CalendarDataSource {
  CalendarSessionSource(List<Appointment> source) {
    appointments = source;
  }

  factory CalendarSessionSource.wrapInSource(BuildContext context, List<Session> sessions) {
    List<Appointment> appointments = <Appointment>[];

    for (Session session in sessions) {
      appointments.add(Appointment(
        startTime: session.date,
        endTime: session.date,
        color: Styles.activeColor(context),
      ));
    }

    return CalendarSessionSource(appointments);
  }
}
