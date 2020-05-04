import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:questionaire/main.dart';
import 'package:questionaire/results.dart';
import 'package:questionaire/splash.dart';

class getjson extends StatelessWidget {
  String questionstoget;

  getjson(this.questionstoget);

  String asset;

  setasset() {
    if (questionstoget == "Popular Culture") {
      asset = "assets/pop.json";
    } else if (questionstoget == "History") {
      asset = "assets/history.json";
    }
  }

  @override
  Widget build(BuildContext context) {
    setasset();
    return FutureBuilder(
      future: DefaultAssetBundle.of(context).loadString(asset),
      builder: (context, snapshot) {
        List data = json.decode(snapshot.data.toString());
        if (data == null) {
          return Scaffold(
            body: Center(
              child: Text(
                "Loading",
              ),
            ),
          );
        } else {
          return questions(data: data);
        }
      },
    );
  }
}

class questions extends StatefulWidget {
  var data;
  var scanSubscription;

  final int waitlength = 400;
  final int buzzlength = 400;


  questions({Key key, @required this.data}) : super(key: key);
  final FlutterBlue flutterBlue = FlutterBlue.instance;
  final List<BluetoothDevice> devicesList = new List<BluetoothDevice>();

  @override
  _questionsState createState() => _questionsState(data);
}

class _questionsState extends State<questions> {

  var blc = splashscreen.bluetoothCharacteristic;
  var data;

  _questionsState(this.data);

  Color colortoshow;
  int points = 0;
  int questionnumber = 1;

  Map<String, Color> buttoncolor = {
    "a": Colors.lightBlueAccent,
    "b": Colors.lightBlueAccent,
    "c": Colors.lightBlueAccent,
    "d": Colors.lightBlueAccent,
  };

  void nextquestion() {
    setState(() {
      if (questionnumber < 11) {
        questionnumber++;
      } else {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => results(points: points),
        ));
      }
      buttoncolor["a"] = Colors.lightBlueAccent;
      buttoncolor["b"] = Colors.lightBlueAccent;
      buttoncolor["c"] = Colors.lightBlueAccent;
      buttoncolor["d"] = Colors.lightBlueAccent;
    });
  }

  void checkAnswer(String answer) {
    if (data[2][questionnumber.toString()] ==
        data[1][questionnumber.toString()][answer]) {
      //checks if the answer is correct
      colortoshow = Colors.green;
      points++;
    } else {
      colortoshow = Colors.red;
      splashscreen.buzz();
    }
    setState(() {
      buttoncolor[answer] = colortoshow;
    });
    Timer(Duration(seconds: 1), nextquestion);
  }

  Widget answerbutton(String answer) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 10.0,
        horizontal: 20.0,
      ),
      child: MaterialButton(
        onPressed: () => checkAnswer(answer),
        child: Text(
          data[1][questionnumber.toString()][answer],
          style: TextStyle(
            fontSize: 16.0,
            color: Colors.white,
          ),
        ),
        color: buttoncolor[answer],
        minWidth: 200.0,
        height: 45.0,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        splashColor: Colors.blue,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: <Widget>[
          Expanded(
            // for the Questions
            flex: 4,
            child: Container(
              padding: EdgeInsets.all(15.0),
              alignment: Alignment.center,
              child: Text(
                data[0][questionnumber.toString()],
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w700),
              ),
            ),
          ),
          Expanded(
            // for the Answers
            flex: 6,
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  answerbutton("a"),
                  answerbutton("b"),
                  answerbutton("c"),
                  answerbutton("d"),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
