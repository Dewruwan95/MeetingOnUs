import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:meetingonus/meetings/add_meeting.dart';
import 'package:meetingonus/screens/authentication/login.dart';
import 'package:meetingonus/screens/authentication/password_reset.dart';
import 'package:meetingonus/screens/authentication/register.dart';
import 'package:flutter/services.dart';
import 'package:meetingonus/screens/home/dashboard.dart';
import 'package:meetingonus/screens/home/home.dart';
import 'package:meetingonus/screens/profile/profile.dart';
import 'package:meetingonus/style/style.dart';
import 'package:splashscreen/splashscreen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(new MyApp());
  });
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
      home: AddMeeting(),
    );
  }
}


