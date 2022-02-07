import 'dart:convert';

class User {
  final String _username;
  final String _authorisationToken;

  User(this._username, this._authorisationToken);

  String get username {
    return _username;
  }

  String get authorisationToken {
    return _authorisationToken;
  }

  String toJson() {
    return '{"username": "$username", "authorisationToken": "$_authorisationToken"}';
  }

  factory User.fromJson(String jsonString) {
    Map<String, dynamic> parsedJson = jsonDecode(jsonString);
    return User(
      parsedJson['username'],
      parsedJson['authorisationToken'],
    );
  }
}

class GlobalUser {
  static User? user;
}
