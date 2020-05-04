import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:questionaire/home.dart';

// ignore: camel_case_types
class splashscreen extends StatefulWidget {
  static BluetoothCharacteristic bluetoothCharacteristic;  //set in discoverServices()
  static buzz() async {
    await bluetoothCharacteristic.write(_getRandomBytes(), withoutResponse: true); // oder [0x00, 0x00, 0xFF, 0x00, 0x00]
  }
  static List<int> _getRandomBytes() {
    final math = Random();
    return[
      math.nextInt(255),
      math.nextInt(255),
      math.nextInt(255),
      math.nextInt(255)
    ];
  }
  @override
  _splashscreenState createState() => _splashscreenState();
}

class _splashscreenState extends State<splashscreen> {

  @override
  void initState() {
    super.initState();
    scanDevices();
    Timer(Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => homepage(),
      ));
    });
  }

  final String device_id = "C9:F7:C0:1A:FA:15";
  final String device_name = "TECO Wearable 6";

  final String SERVICE_UUID = "713d0000-503e-4c75-ba94-3148f18d941e";
  final String CHARACTERISTIC_1_UUID  =
      "713d0001-503e-4c75-ba94-3148f18d941e"; //Anzahl der angeschlossenen Motoren (z.B. 4 oder 5)
  final String CHARACTERISTIC_2_UUID  =
      "713D0002-503E-4C75-BA94-3148F18D941E"; //Maximale Update-Frequenz für Motoren, z.B. 12 (“Updates pro Sekunde”)
  final String CHARACTERISTIC_3_UUID  =
      "713d0003-503e-4c75-ba94-3148f18d941e"; //schaltet Motoren auf gegebene Stärken


  FlutterBlue flutterBlue = FlutterBlue.instance;
  bool isReady;
  Stream<List<int>> stream;

  BluetoothDevice device;     //set in scanDevices()
  BluetoothDeviceState deviceState;
  BluetoothService bluetoothService;  //set in discoverServices()



  void scanDevices() async{
    // Start scanning
    flutterBlue.startScan(timeout: Duration(seconds: 4));

    // Listen to scan results
    flutterBlue.scanResults.listen((results) {
      // do something with scan results
      for (ScanResult r in results) {
        if (r.device.name == device_name) {
          device = r.device;
          print("found device");
          connectToDevice();
        }
      }
    });
    flutterBlue.stopScan();
  }


  discoverServices() async{
    if (device == null) {
      print("device is null");
      return;
    }
    print("before finding serv");
    List<BluetoothService> services = await device.discoverServices();
    services.forEach((service) {
      print(service.uuid.toString());
      if (service.uuid.toString() == SERVICE_UUID) {
        bluetoothService = service;
        print("found service");
        service.characteristics.forEach((characteristic) {
          print(characteristic.uuid.toString());
          if (characteristic.uuid.toString() == CHARACTERISTIC_3_UUID) {
            splashscreen.bluetoothCharacteristic = characteristic;
            print("found character");
          }
        });
      }
    });

  }

  connectToDevice() async {
    await device.connect();
    print("in connect");
    discoverServices();
  }

  disconnectFromDevice() {
    if (device == null) {
      return;
    }

    device.disconnect();
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

