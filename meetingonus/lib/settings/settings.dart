import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:meetingonus/screens/authentication/password_reset.dart';
import 'package:meetingonus/screens/home/dashboard.dart' as myDashboard;
import 'package:meetingonus/screens/home/drawer.dart';
import 'package:meetingonus/style/style.dart';

final FirebaseAuth auth = FirebaseAuth.instance;
final databaseReference = FirebaseDatabase.instance.reference();
CollectionReference users = FirebaseFirestore.instance.collection('users');

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {

  onChanged(bool value) {
    setState(
      () {
        myDashboard.pushNotificationValue = value;
      },
    );
  }

  //---------------------- get user details from firebase----------------

  // void inputData() {
  //   final User user = auth.currentUser;
  //   final uid = user.uid;
  //
  //   users.doc(uid).snapshots().listen((event) {
  //     userName = event.data()["user_name"];
  //     userProfileUrl = event.data()["profile_url"];
  //     email = event.data()["email"];
  //   });
  // }

  // //------------- create profile pic using url ----------------------
  // Widget profileImage() {
  //   return userProfileUrl != null
  //       ? ClipOval(
  //           child: Image.network(
  //             userProfileUrl,
  //             width: 100,
  //             height: 100,
  //             fit: BoxFit.cover,
  //           ),
  //         )
  //       : Image.asset(
  //           "lib/assets/icon/user.png",
  //           width: 100,
  //           height: 100,
  //           color: Colors.white,
  //         );
  // }
//----------------------- navigation animation for Dashboard ------------------------
  Route _navigateToPasswordReset() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => PasswordReset(),
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

  //------------------------------- Start Build Function -------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: bgGrey,
        drawer: MyDrawer(),
        appBar: AppBar(
          elevation: 0.0,
          title: Text(
            "Settings",
            style: subBoldTitleWhite(),
          ),
          iconTheme: IconThemeData(color: Colors.white),
        ),
        body: ListView(
          padding: EdgeInsets.all(20.0),
          children: <Widget>[
            Container(
              height: 70.0,
              margin: EdgeInsets.only(bottom: 14.0),
              width: screenHeight(context),
              padding: EdgeInsets.all(14.0),
              decoration: new BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  new BoxShadow(
                    color: Colors.grey.shade300,
                    blurRadius: 8.0,
                  ),
                ],
              ),
              child: Row(
                children: <Widget>[
                  CircleAvatar(
                    backgroundColor: primary.withOpacity(0.4),
                    child: myDashboard.globalUser.createProfileImage(),
                  ),
                  Flexible(
                    child: Padding(
                      padding: EdgeInsets.only(left: 10.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            myDashboard.globalUser.getUserName(),
                            style: textStyleOrangeSS(),
                          ),
                          Text(
                            myDashboard.globalUser.getUserEmail(),
                            style: smallBoldDescription(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
                height: 70.0,
                width: screenHeight(context),
                padding: EdgeInsets.all(8.0),
                margin: EdgeInsets.only(bottom: 14.0),
                decoration: new BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    new BoxShadow(
                      color: Colors.grey.shade300,
                      blurRadius: 8.0,
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        IconButton(
                          icon: Image.asset(
                            "lib/assets/icon/notification.png",
                            height: 22.0,
                            width: 22.0,
                            color: Colors.black,
                          ),
                          onPressed: () {},
                        ),
                        Text(
                          "Push Notifications",
                          style: textSmallStyleGreySS(),
                        ),
                      ],
                    ),
                    Container(
                      width: screenWidth(context) * 0.3,
                      child: SwitchListTile(
                        value: myDashboard.pushNotificationValue,
                        onChanged: (bool value) {
                          onChanged(value);
                        },
                        activeColor: primary,
                      ),
                    ),
                  ],
                )),
            InkWell(
              onTap: () {
                Navigator.of(context).push(_navigateToPasswordReset());
              },
              child: Container(
                height: 70.0,
                width: screenHeight(context),
                padding: EdgeInsets.all(8.0),
                margin: EdgeInsets.only(bottom: 14.0),
                decoration: new BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    new BoxShadow(
                      color: Colors.grey.shade300,
                      blurRadius: 8.0,
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        IconButton(
                          icon: Image.asset(
                            "lib/assets/icon/completed.png",
                            height: 22.0,
                            width: 22.0,
                            color: Colors.black,
                          ),
                          onPressed: () {},
                        ),
                        Text(
                          "Reset Password",
                          style: textSmallStyleGreySS(),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: Image.asset(
                        "lib/assets/icon/arrow.png",
                        height: 22.0,
                        width: 22.0,
                      ),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}
