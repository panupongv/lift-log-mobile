import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:http/http.dart';
import 'package:liftlogmobile/models/user.dart';

class APIService {
  static const String host = "https://lift-log-prod.herokuapp.com/api";
  static const Map<String, String> defaultJsonHeader = <String, String>{
    'Content-Type': 'application/json; charset=UTF-8',
  };

  // Authentication

  static Future<Either<User, String>> login(
      final String username, final String password) async {
    final Uri url = Uri.parse("$host/auth/login");

    Response response = await post(
      url,
      headers: defaultJsonHeader,
      body: jsonEncode(<String, String>{
        'username': username,
        'password': password,
      }),
    );

    Map<String, dynamic> responseBody = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return Left(User(username, responseBody['token']));
    } else {
      return Right(responseBody['message']);
    }
  }

  static Future<Either<bool, String>> signup(String username, String password) async {
    final Uri url = Uri.parse("$host/auth/signup");
    Response response = await post(
      url,
      headers: defaultJsonHeader,
      body: jsonEncode(<String, String>{
        'username': username,
        'password': password,
      }),
    );

    if (response.statusCode == 201) {
      return const Left(true);
    }
    return Right(jsonDecode(response.body)['message']);
  }
}
