import 'package:flutter/material.dart';
import 'package:questionaire/splash.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'Questionaire',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: splashscreen(),
    );
  }
}