import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:meetingonus/screens/authentication/login.dart';
import 'package:meetingonus/screens/profile/profile.dart';
import 'package:meetingonus/settings/help.dart';
import 'package:meetingonus/settings/settings.dart';
import 'package:meetingonus/style/style.dart';
import 'package:meetingonus/screens/home/dashboard.dart' as myDashboard;

class MyDrawer extends StatefulWidget {
  @override
  _MyDrawerState createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  bool selected = false;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  //----------------------- navigation animation for Dashboard ------------------------
  Route _navigateToDashboard() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          myDashboard.Dashboard(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(0.0, 1.0);
        var end = Offset.zero;
        var curve = Curves.fastOutSlowIn;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  //----------------------- navigation animation for profile ------------------------
  Route _navigateToProfile() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => Profile(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(0.0, 1.0);
        var end = Offset.zero;
        var curve = Curves.fastOutSlowIn;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  //----------------------- navigation animation for settings ------------------------
  Route _navigateToSettings() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => Settings(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(0.0, 1.0);
        var end = Offset.zero;
        var curve = Curves.fastOutSlowIn;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  //----------------------- navigation animation for Dashboard ------------------------
  Route _navigateToHelp() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => Help(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(0.0, 1.0);
        var end = Offset.zero;
        var curve = Curves.fastOutSlowIn;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

//-------------------- sign out google ----------------------------
  Future<Login> _signOutGoogle() async {
    await FirebaseAuth.instance.signOut();

    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => MySplashScreenToLogin(),
        ),
        (Route<dynamic> route) => false);
  }

  //----------------- sign out facebook ---------------------
  static final FacebookLogin facebookSignIn = new FacebookLogin();

  //------------------------------------ Start Build Function ------------------------
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        canvasColor: Colors.white,
      ),
      child: Drawer(
        child: ListView(
          children: <Widget>[
            Container(
              margin: EdgeInsets.all(12.0),
              alignment: AlignmentDirectional.topEnd,
              child: Image.asset("lib/assets/icon/sidebaricon.png"),
            ),
            Center(
              child: Column(
                children: <Widget>[
                  InkWell(
                    onTap: () {
                      setState(() {
                        selected = true;
                      });
                      Navigator.of(context).pop();
                      Navigator.of(context).push(_navigateToProfile());
                    },
                    child: ListTile(
                      leading: Icon(
                        Icons.person_outline,
                        color: Colors.black,
                      ),
                      title: Text(
                        "Profile",
                        style: productTitle(),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).push(_navigateToDashboard());
                    },
                    child: ListTile(
                      leading: Image.asset(
                        "lib/assets/icon/home.png",
                        height: 22.0,
                        width: 22.0,
                      ),
                      title: Text(
                        "Home",
                        style: productTitle(),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).push(_navigateToSettings());
                    },
                    child: ListTile(
                      leading: Image.asset(
                        "lib/assets/icon/settings.png",
                        height: 22.0,
                        width: 22.0,
                      ),
                      title: Text(
                        "Settings",
                        style: productTitle(),
                      ),
                    ),
                  ),
//                  InkWell(
//                    onTap: () {
//                      Navigator.of(context).pop();
//                    },
//                    child: ListTile(
//                      leading: Image.asset("lib/assets/icon/info.png", height: 22.0, width: 22.0,),
//                      title: Text("About us", style: productTitle(),),
//                    ),
//                  ),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).push(_navigateToHelp());
                    },
                    child: ListTile(
                      leading: Image.asset(
                        "lib/assets/icon/help.png",
                        height: 22.0,
                        width: 22.0,
                      ),
                      title: Text(
                        "Help",
                        style: productTitle(),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () async {
                      _signOutGoogle();
                      // Navigator.of(context).pop();
                      // SharedPreferences prefs =
                      //     await SharedPreferences.getInstance();
                      // prefs.setBool('fbLogin', false);
                      // prefs.setBool('login', false);
                      // signOutGoogle() || _facebookLogOut() || _twitterLogout();
                    },
                    child: ListTile(
                      leading: Image.asset(
                        "lib/assets/icon/signout.png",
                        height: 22.0,
                        width: 22.0,
                      ),
                      title: Text(
                        "Sign out",
                        style: productTitle(),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
