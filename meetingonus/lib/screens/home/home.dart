import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meetingonus/style/style.dart';
import 'package:splashscreen/splashscreen.dart';

class MySplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      seconds: 5,
      navigateAfterSeconds: SecondActivity(),
      image: Image.asset(
        "lib/assets/bg/generallogo.png",
      ),
      backgroundColor: Colors.white,
      photoSize: 140.0,
      loaderColor: primary,
    );
  }
}

class SecondActivity extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Second Screen"),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Text(
          "Done",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30.0),
        ),
      ),
    );
  }
}
