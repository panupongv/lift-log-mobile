import 'package:intl/intl.dart';

class Session {
  String _id;
  String _name;
  DateTime _date;
  String _location;

  static final DateFormat _displayDateFormat = DateFormat("dd/MM/yyyy");
  static final DateFormat _databaseDateFormat = DateFormat("yyyy-MM-dd");

  Session(this._id, this._name, this._date, this._location);

  set name(String newName) {
    assert(newName.isNotEmpty);
    _name = newName;
  }

  set date(DateTime newDate) {
    _date = newDate;
  }

  set location(String newLocation) {
    _location = newLocation;
  }

  String get id => _id;

  String get name => _name;

  DateTime get date => _date;

  String get location => _location;

  @override
  String toString() {
    return "Session {name: $_name, date: $_date, location: $_location}";
  }

  factory Session.fromJson(json) {
    String dateString = json['date'];
    DateTime date = DateTime.parse(dateString);
    return Session(json['_id'], json['name'], date, json['location']);
  }

  static String convertDateToDisplayFormat(DateTime date) {
    return _displayDateFormat.format(date);
  }

  static String convertDateToDatabaseFormat(DateTime date) {
    return "${_databaseDateFormat.format(date.toUtc())}Z";
  }

  DateTime fromDisplayFormatDate(String dateString) {
    return DateTime.parse(dateString);
  }

  String getDayOfWeek() {
    return DateFormat("EEEE").format(_date);
  }

  String getDateInDisplayFormat() => convertDateToDisplayFormat(_date);

  String getDateInDatabaseFormat() => convertDateToDatabaseFormat(_date);
}
