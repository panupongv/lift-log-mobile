
import 'package:liftlogmobile/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {

  static const String currentUserKey = "lift-log-current-user";

  static Future<void> saveUser(User user) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString(currentUserKey, user.toJson());
  }

  static Future<User?> loadSavedUser() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String savedUserString = preferences.getString(currentUserKey) ?? "";
    if (savedUserString != "") {
      return User.fromJson(savedUserString);
    }
    return null;
  }

  static Future<void> removeSavedUser() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.remove(currentUserKey);
  }
}