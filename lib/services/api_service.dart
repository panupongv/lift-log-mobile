import 'dart:convert';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:http/http.dart';
import 'package:liftlogmobile/models/exercise.dart';
import 'package:liftlogmobile/models/session.dart';
import 'package:liftlogmobile/models/user.dart';
import 'package:liftlogmobile/models/workout.dart';

class APIService {
  static const String _host = "https://lift-log-prod.herokuapp.com/api";
  static const Map<String, String> _defaultJsonHeader = <String, String>{
    'Content-Type': 'application/json; charset=UTF-8',
  };

  static Map<String, String> jsonHeaderWithAuthToken(User user) {
    return <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer ${user.authorisationToken}'
    };
  }

  static String parameteriseQuery(Map<String, String> params) {
    return "?" + params.entries.map((e) => "${e.key}=${e.value}").join("&");
  }

  // Authentication

  static Future<Either<User, String>> login(
      final String username, final String password) async {
    final Uri url = Uri.parse("$_host/auth/login");

    Response response = await post(
      url,
      headers: _defaultJsonHeader,
      body: jsonEncode(<String, String>{
        'username': username,
        'password': password,
      }),
    );

    Map<String, dynamic> responseBody = jsonDecode(response.body);
    if (response.statusCode == HttpStatus.ok) {
      return Left(User(username, responseBody['token']));
    } else {
      return Right(responseBody['message']);
    }
  }

  static Future<Either<bool, String>> signup(
      String username, String password) async {
    final Uri url = Uri.parse("$_host/auth/signup");
    Response response = await post(
      url,
      headers: _defaultJsonHeader,
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

  static Future<List<Exercise>> getExercises() async {
    User user = GlobalUser.user!;
    final Uri url = Uri.parse("$_host/${user.username}/exercises");
    Response response = await get(url, headers: jsonHeaderWithAuthToken(user));

    if (response.statusCode == HttpStatus.ok) {
      dynamic json = jsonDecode(response.body);
      List<dynamic> rawExercises = json['exercises'];
      return rawExercises.map((e) => Exercise.fromJson(e)).toList();
    }
    return [];
  }

  static Future<bool> createExercise(String exerciseName) async {
    User user = GlobalUser.user!;
    final Uri url = Uri.parse("$_host/${user.username}/exercises");
    Response response = await post(
      url,
      headers: jsonHeaderWithAuthToken(user),
      body: jsonEncode(<String, String>{'exerciseName': exerciseName}),
    );

    if (response.statusCode == HttpStatus.created) {
      return true;
    }
    return false;
  }

  static Future<bool> updateExercise(Exercise exercise, String newName) async {
    User user = GlobalUser.user!;
    final Uri url =
        Uri.parse("$_host/${user.username}/exercises/${exercise.id}");
    Response response = await put(
      url,
      headers: jsonHeaderWithAuthToken(user),
      body: jsonEncode(<String, String>{'exerciseName': newName}),
    );

    return response.statusCode == HttpStatus.ok;
  }

  static Future<bool> deleteExercise(Exercise exercise) async {
    User user = GlobalUser.user!;
    final Uri url =
        Uri.parse("$_host/${user.username}/exercises/${exercise.id}");
    Response response = await delete(
      url,
      headers: jsonHeaderWithAuthToken(user),
    );

    return response.statusCode == HttpStatus.ok;
  }

  // Sessions

  static Future<List<Session>> getSessions(int start, int limit) async {
    User user = GlobalUser.user!;
    Map<String, String> query = {
      'start': start.toString(),
      'limit': limit.toString(),
    };

    final Uri url = Uri.parse(
        "$_host/${user.username}/sessions" + parameteriseQuery(query));

    Response response = await get(url, headers: jsonHeaderWithAuthToken(user));

    if (response.statusCode == HttpStatus.ok) {
      dynamic json = jsonDecode(response.body);
      List<dynamic> rawSessions = json['sessions'];
      return rawSessions.map((s) => Session.fromJson(s)).toList();
    }
    return [];
  }

  static Future<List<Session>> getSessionsByDate(DateTime startDate, DateTime endDate) async {
    User user = GlobalUser.user!;
    Map<String, String> query = {
      'startDate': Session.convertDateToDatabaseFormat(startDate),
      'endDate': Session.convertDateToDatabaseFormat(endDate),
    };

    final Uri url = Uri.parse(
        "$_host/${user.username}/sessions/dates" + parameteriseQuery(query));

    Response response = await get(url, headers: jsonHeaderWithAuthToken(user));

    if (response.statusCode == HttpStatus.ok) {
      dynamic json = jsonDecode(response.body);
      List<dynamic> rawSessions = json['sessions'];
      return rawSessions.map((s) => Session.fromJson(s)).toList();
    }
    return [];
  } 

  static Future<Session?> createSession(Session session) async {
    User user = GlobalUser.user!;
    final Uri url = Uri.parse("$_host/${user.username}/sessions");

    Response response = await post(url,
        headers: jsonHeaderWithAuthToken(user),
        body: jsonEncode(<String, String>{
          "name": session.name,
          "date": session.getDateInDatabaseFormat(),
          "location": session.location,
        }));

    if (response.statusCode == HttpStatus.created) {
      dynamic json = jsonDecode(response.body);
      return Session.fromJson(json["createdSession"]);
    }
    return null;
  }

  static Future<bool> updateSession(Session session) async {
    User user = GlobalUser.user!;
    final Uri url = Uri.parse("$_host/${user.username}/sessions/${session.id}");

    Response response = await put(url,
        headers: jsonHeaderWithAuthToken(user),
        body: jsonEncode(<String, String>{
          "name": session.name,
          "date": session.getDateInDatabaseFormat(),
          "location": session.location,
        }));

    return response.statusCode == HttpStatus.ok;
  }

  static Future<bool> deleteSession(Session session) async {
    User user = GlobalUser.user!;
    final Uri url = Uri.parse("$_host/${user.username}/sessions/${session.id}");

    Response response =
        await delete(url, headers: jsonHeaderWithAuthToken(user));

    return response.statusCode == HttpStatus.ok;
  }

  // Workouts

  static Future<List<Workout>> getWorkouts(Session session) async {
    User user = GlobalUser.user!;
    final Uri url = Uri.parse("$_host/${user.username}/sessions/${session.id}");

    Response response = await get(url, headers: jsonHeaderWithAuthToken(user));

    if (response.statusCode == HttpStatus.ok) {
      dynamic json = jsonDecode(response.body);
      List<dynamic> rawWorkouts = json['session']['workouts'];
      return rawWorkouts.map((w) => Workout.fromJson(w)).toList();
    }
    return [];
  }

  static Future<bool> createWorkout(Session session, Workout workout) async {
    User user = GlobalUser.user!;
    final Uri url = Uri.parse("$_host/${user.username}/sessions/${session.id}");

    Response response = await post(url,
        headers: jsonHeaderWithAuthToken(user),
        body: jsonEncode(<String, String>{
          "exerciseId": workout.exerciseId,
          "content": workout.content
        }));

    return response.statusCode == HttpStatus.created;
  }

  static Future<bool> updateWorkout(Session session, Workout workout) async {
    User user = GlobalUser.user!;
    final Uri url = Uri.parse(
        "$_host/${user.username}/sessions/${session.id}/${workout.id}");

    Response response = await put(url,
        headers: jsonHeaderWithAuthToken(user),
        body: jsonEncode(<String, String>{
          "exerciseId": workout.exerciseId,
          "content": workout.content
        }));

    return response.statusCode == HttpStatus.ok;
  }

  static Future<bool> deleteWorkout(Session session, Workout workout) async {
    User user = GlobalUser.user!;
    final Uri url = Uri.parse(
        "$_host/${user.username}/sessions/${session.id}/${workout.id}");

    Response response = await delete(
      url,
      headers: jsonHeaderWithAuthToken(user),
    );

    return response.statusCode == HttpStatus.ok;
  }

  static Future<Tuple4<Session, Workout, Session?, Session?>?> getHistory(
      Session session, Exercise exercise, int offset) async {
    User user = GlobalUser.user!;
    Map<String, String> queryParams = {
      'date': session.getDateInDatabaseFormat(),
      'offset': offset.toString(),
    };
    final Uri url = Uri.parse(
        "$_host/${user.username}/sessions/history/${exercise.id}" +
            parameteriseQuery(queryParams));

    Response response = await get(url, headers: jsonHeaderWithAuthToken(user));

    if (response.statusCode == HttpStatus.ok) {
      dynamic json = jsonDecode(response.body);

      Session mainSession = Session.fromJson(json['session']);
      Workout mainWorkout = Workout.fromJson(json['session']['workouts']);
      Session? nextSession = json['newerSession'] != null
          ? Session.fromJson(json['newerSession'])
          : null;
      Session? previousSession = json['olderSession'] != null
          ? Session.fromJson(json['olderSession'])
          : null;

      return Tuple4(mainSession, mainWorkout, nextSession, previousSession);
    }
    return null;
  }
}
