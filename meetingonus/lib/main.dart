import 'package:flutter/material.dart';
import 'package:meetingonus/screens/authentication/login.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Meeting on Us',
      home: Login(),
    );
  }
}
