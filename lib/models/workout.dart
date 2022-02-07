class Workout {
  String _id;
  String _exerciseId;
  String _content;

  static const String setSeparator = ";";
  static const String weightRepsSeparator = "x";
  static const String defaultExerciseId = "000000000000000000000000";

  Workout(this._id, this._exerciseId, this._content);

  String get id => _id;
  String get exerciseId => _exerciseId;
  String get content => _content;
  int get sets => _content == ""? 0 : _content.split(setSeparator).length;

  static bool validateContent(String content) {
    if (content.isEmpty) return true;
    List<String> sets = content.split(setSeparator);
    for (String setString in sets) {
      List<String> weightAndReps = setString.split(weightRepsSeparator);
      if (weightAndReps.length != 2) return false;
      double weight = double.tryParse(weightAndReps[0]) ?? -1;
      int reps = int.tryParse(weightAndReps[1]) ?? -1;
      if (weight < 0 || reps < 0) return false;
    }
    return true;
  }

  factory Workout.blankWorkout() {
    return Workout("", defaultExerciseId, "");
  }

  factory Workout.fromJson(json) {
    return Workout(json['_id'], json['exerciseId'], json['content']);
  }

  set id(String newId) {
    if (newId.isNotEmpty) {
      _id = newId;
    }
  }

  set exerciseId(String newExerciseId) {
    if (newExerciseId.isNotEmpty) {
    _exerciseId = newExerciseId;
    }
  }

  set content(String content) {
    if (validateContent(content)) _content = content;
  }

  @override
  String toString() {
    return "ID: $_id, Exercise ID: $_exerciseId, Content: $_content";
  }

}
