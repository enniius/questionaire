import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:questionaire/main.dart';
import 'package:flutter_ble_lib/flutter_ble_lib.dart';
import 'package:questionaire/results.dart';

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

  static final String FINGER_0 = "qgAAAA==";
  static final String FINGER_1 = "AKoAAA==";
  static final String FINGER_2 = "AACqAA==";
  static final String FINGER_3 = "AAAAqg==";
  static final String ALL_STOP = "AAAAAA==";
  var list = [FINGER_0,FINGER_1];



  final String device_id = "C9:F7:C0:1A:FA:15";
  final String device_name = "TECO Wearable 007";

  final String service = "713D0000-503E-4C75-BA94-3148F18D941E";
  final String char1 =
      "713D0001-503E-4C75-BA94-3148F18D941E"; //Anzahl der angeschlossenen Motoren (z.B. 4 oder 5)
  final String char2 =
      "713D0002-503E-4C75-BA94-3148F18D941E"; //Maximale Update-Frequenz für Motoren, z.B. 12 (“Updates pro Sekunde”)
  final String char3 =
      "713D0003-503E-4C75-BA94-3148F18D941E"; //schaltet Motoren auf gegebene Stärken

  questions({Key key, @required this.data}) : super(key: key);

  @override
  _questionsState createState() => _questionsState(data);
}

class _questionsState extends State<questions> {
  var data;
  _questionsState(this.data);

  @override
  Future<void> initState() async {
    super.initState();

    BleManager bleManager = BleManager();
    await bleManager.createClient(); //ready to go!

    bleManager.startPeripheralScan(
      uuids: [
        widget.service,
      ],
    ).listen((scanResult) async {
      //Scan one peripheral and stop scanning
      print("Scanned Peripheral ${scanResult.peripheral.name}, RSSI ${scanResult.rssi}");

      Peripheral peripheral = scanResult.peripheral;
      peripheral.observeConnectionState(emitCurrentValue: true, completeOnDisconnect: true)
          .listen((connectionState) {
        print("Peripheral ${scanResult.peripheral.identifier} connection state is $connectionState");
      });
      await peripheral.connect();
      bool connected = await peripheral.isConnected();
      //await peripheral.disconnectOrCancelConnection();
      print("imhere");
      //assuming peripheral is connected
      await peripheral.discoverAllServicesAndCharacteristics();
      List<Service> services = await peripheral.services(); //getting all services
      List<Characteristic> characteristics1 = await peripheral.characteristics(widget.char1);
      List<Characteristic> characteristics2 = await services.firstWhere(
              (service) => service.uuid == widget.service).characteristics();

      //characteristics1 and characteristics2 have the same contents

      peripheral.writeCharacteristic(
          widget.service,
          widget.char3,
          Uint8List.fromList([0xFF]),
          false);

      bleManager.stopPeripheralScan();
    });






    bleManager.destroyClient(); //remember to release native resources when you're done!
  }


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
      //TODO: vibrate if wrong
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
