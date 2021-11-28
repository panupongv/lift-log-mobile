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
    assert(newDate != null);
    _date = newDate;
  }

  set location(String newLocation) {
    assert(newLocation.isNotEmpty);
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

  DateTime fromDisplayFormatDate(String dateString) {
    return DateTime.parse(dateString);
  }

  String getDateInDisplayFormat() {
    return _displayDateFormat.format(_date);
  }

  String getDayOfWeek() {
    return DateFormat("EEEE").format(_date);
  }

  String getDateInDatabaseFormat() {
    return "${_databaseDateFormat.format(_date.toUtc())}Z";
  }
}
