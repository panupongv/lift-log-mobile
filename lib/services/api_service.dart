import 'dart:convert';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:http/http.dart';
import 'package:liftlogmobile/models/exercise.dart';
import 'package:liftlogmobile/models/user.dart';

class APIService {
  static const String host = "https://lift-log-prod.herokuapp.com/api";
  static const Map<String, String> defaultJsonHeader = <String, String>{
    'Content-Type': 'application/json; charset=UTF-8',
  };
  static Map<String, String> jsonHeaderWithAuthToken(User user) {
    return <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer ${user.authorisationToken}'
    };
  }

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

  static Future<Either<bool, String>> signup(
      String username, String password) async {
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

  // Exercises

  static Future<List<Exercise>> getExercises(User user) async {
    final Uri url = Uri.parse("$host/${user.username}/exercises");
    Response response = await get(url, headers: jsonHeaderWithAuthToken(user));

    if (response.statusCode == 200) {
      dynamic json = jsonDecode(response.body);
      List<dynamic> rawExercises = json['exercises'];
      return rawExercises.map((e) => Exercise.fromJson(e)).toList();
    } 
    return [];
  }

  static Future<List<Exercise>> updateExercise(User user, Exercise exercise, String newName) async {
    final Uri url = Uri.parse("$host/${user.username}/exercises/${exercise.id}");
    Response response = await put(
      url,
      headers: jsonHeaderWithAuthToken(user),
      body: jsonEncode(<String, String>{
        'exerciseName': newName 
      }),
    );

    print(response);
    print(response.statusCode);
    print(response.body);

    if (response.statusCode == 200) {
      dynamic json = jsonDecode(response.body);
      print("Updated: " + json.toString());
      return [];
    }
    return [];
  }
}
