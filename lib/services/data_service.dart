import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:http/http.dart';
import 'package:liftlogmobile/models/user.dart';

class DataService {
  static const String baseRoute = "https://lift-log-prod.herokuapp.com/api";

  // Authentication

  static Future<Either<User, String>> login(
      final String username, final String password) async {
    final Uri url = Uri.parse("$baseRoute/auth/login");

    Response response = await post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'username': username,
        'password': password,
      }),
    );

    Map<String, dynamic> responseBody = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return Left(User(username, responseBody['token']));
    } else {
      return Right("no");
    }
  }
}
