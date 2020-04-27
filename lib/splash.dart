import 'dart:async';

import 'package:flutter/material.dart';
import 'package:questionaire/home.dart';

// ignore: camel_case_types
class splashscreen extends StatefulWidget {
  @override
  _splashscreenState createState() => _splashscreenState();
}

class _splashscreenState extends State<splashscreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => homepage(),
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      body: Center(
        child: Text(
          "Questionaire",
          style: TextStyle(
            fontSize: 50.0,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

