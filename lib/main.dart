import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

String baseUrl = "https://lift-log-prod.herokuapp.com/api";

void main() {
  runApp(const LiftLogApp());
}

class LiftLogApp extends StatelessWidget {
  const LiftLogApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: TempPage(),
    );
  }
}

class TempPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextButton(onPressed: () async {


        final xxx = await http.get(
          Uri.parse("$baseUrl/produser/exercises"),
          headers: {
            HttpHeaders.authorizationHeader: 'bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VybmFtZSI6InByb2R1c2VyIiwiaWF0IjoxNjI5NjYzNjk2fQ._8Uj9JXE-JUugIbBXgCf-IOsWhBiEsQuREUKjCwmYjA'
          },
        );
        print("MOFO "  + xxx.body.toString());
      }, 
      child: const Text("Hello")),
    );
  }


}
