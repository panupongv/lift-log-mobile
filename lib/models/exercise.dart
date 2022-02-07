import 'package:liftlogmobile/services/api_service.dart';

class Exercise {
  String _id;
  String _name;

  Exercise(this._id, this._name);

  set id(String newId) {
    assert(newId.isNotEmpty);
    _id = newId;
  }

  set name(String newName) {
    assert(newName.isNotEmpty);
    _name = newName;
  }

  String get id => _id;

  String get name => _name;

  factory Exercise.fromJson(json) {
    return Exercise(json['_id'], json['name']);
  }

  @override
  String toString() {
    return "id: $id, name: $name";
  }

}
