import 'package:flutter/material.dart';



class results extends StatefulWidget {
  int points;
  results({Key key, @required this.points}) : super(key : key);
  @override
  _resultsState createState() => _resultsState(points);
}

class _resultsState extends State<results> {
  int points;
  _resultsState(this.points);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Result"
        ),
      ),
      body: Center(
        child: Text(
          "you have answered $points questions from 11",
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
        ),
        ),
      )
    );
  }

}
