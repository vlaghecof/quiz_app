import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'Home.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurpleAccent,
        title: Center(
          child: Text(
            "Welcome!",
            style: TextStyle(color: Colors.black),
          ),
        ),
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/splash2.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Center(
            child: Text(" "), //Image.asset('assets/splash.jpg'),
          ),
          SizedBox(
            width: 10,
            height: 400,
          ),
          RaisedButton(
              color: Colors.indigo,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: <Color>[
                      Colors.indigo,
                      Colors.deepPurple,
                      Colors.deepPurpleAccent,
                    ],
                  ),
                ),
                padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                child: Text(
                  "Ready?",
                  style: TextStyle(fontSize: 20),
                ),
              ),
              onPressed: () => Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                      builder: (BuildContext context) => HomePage()))),
        ]),
      ),
    );
  }
}
