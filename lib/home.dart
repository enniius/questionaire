import 'package:flutter/material.dart';
import 'package:questionaire/questions.dart';

class homepage extends StatefulWidget {
  @override
  _homepageState createState() => _homepageState();
}

class _homepageState extends State<homepage> {

  List<String> images = [
    "images/pop.png",
    "images/history.png",
  ];

  Widget customcard(String quizName, String inputImage){
    return Padding(
      padding: EdgeInsets.all(
        20.0,
      ),
      child: InkWell(
        onTap: (){
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => getjson(quizName),

          ));
          },
        child: Material(
          color: Colors.amber,
          elevation: 10.0,
          borderRadius: BorderRadius.circular(20.0),
          child: Container(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 10.0,
                  ),
                  child: Material(
                    elevation: 5.0,
                    borderRadius: BorderRadius.circular(100.0),
                    child: Container(
                      height: 200,
                      width: 200,
                      child: ClipOval(
                        child: Image(
                          fit: BoxFit.cover,
                          image: AssetImage(
                            inputImage,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Center(
                  child: Text(
                    quizName,
                    style: TextStyle(
                      fontSize: 24.0,
                      fontStyle: FontStyle.normal,
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(20.0),
                  child: Text(
                    "Questions in the $quizName Category",
                    style: TextStyle(
                      fontSize: 17.0,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Questionaire",
        ),
      ),
      body: ListView(
        children: <Widget>[
          customcard("Popular Culture", images[0]),
          customcard("History", images[1]),
        ],
      ),
    );
  }
}
