import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:meetingonus/screens/home/drawer.dart';
import 'package:meetingonus/style/style.dart';
import 'package:meetingonus/service/user_service.dart' as myUser;

final FirebaseAuth auth = FirebaseAuth.instance;
final databaseReference = FirebaseDatabase.instance.reference();
CollectionReference users = FirebaseFirestore.instance.collection('users');

String userStateText = '';

myUser.MyUser globalUser;

bool pushNotificationValue = false;

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  myUser.MyUser currentUser = myUser.MyUser();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  String dateNow = DateFormat('d MMM yyyy').format(DateTime.now());
  int _currentIndex = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    inputData();
    getLecturerStatus();
  }

  void createGlobalUser() {
    globalUser = currentUser;
  }

//--------------- get user details  --------------------------
  Future<void> inputData() {
    final User user = auth.currentUser;
    final uid = user.uid;

    users.doc(uid).snapshots().listen((event) {
      currentUser.setUserId(uid);
      currentUser.setUserName(event.data()["user_name"]);
      currentUser.setUserEmail(event.data()["email"]);
      currentUser.setUserProfileUrl(event.data()["profile_url"]);
      // userNameGlobal = event.data()["user_name"];
      // userProfileUrlGlobal = event.data()["profile_url"];
      // userEmailGlobal = event.data()["email"];
    });

    createGlobalUser();
  }

  //--------------------------- get lecturer status from firebase realtime database --------------
  void getLecturerStatus() {
    databaseReference.child('UserStatus').onValue.listen((event) {
      var snapshot = event.snapshot;
      setState(() {
        String value = snapshot.value['CurrentStatus'];
        if (value == 'active') {
          userStateText = 'Lecturer in the room now';
        } else {
          userStateText = 'Lecturer not in the room now';
        }
      });
    });
    // databaseReference.once().then((DataSnapshot snapshot) {
    //   setState(() {
    //     currentUserStatus = (snapshot.value['UserStatus']);
    //
    //     if (currentUserStatus == 'active') {
    //       userStateText = 'Lecturer in the room now';
    //     }else{
    //       userStateText='Lecturer not in the room now';
    //     }
    //   });
    // });
  }

// //---------------------- get user details from firebase----------------
//
//   void inputData() {
//     final User user = auth.currentUser;
//     final uid = user.uid;
//
//     users.doc(uid).snapshots().listen((event) {
//       userName = event.data()["user_name"];
//     });
//   }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  Widget appBarTitle = Text(
    DateFormat('d MMM yyyy').format(DateTime.now()),
    style: smallAddressWhite(),
  );

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          title: appBarTitle,
          iconTheme: IconThemeData(color: Colors.white),
          backgroundColor: primary,
          actions: [],
        ),
        drawer: MyDrawer(),
        backgroundColor: bgGrey,
        body: Scaffold(
          key: _scaffoldKey,
          backgroundColor: bgGrey,
          body: Container(
            child: ListView(
              shrinkWrap: true,
              physics: ScrollPhysics(),
              children: <Widget>[
                Container(
                  alignment: Alignment.center,
                  height: 30.0,
                  child: Text(
                    "Dear ${currentUser.getUserName()}, ${userStateText}",
                    style: smallAddressWhiteSI(),
                  ),
                  color: grey.withOpacity(0.66),
                ),
                Container(
                  height: 80.0,
                  child: BottomNavigationBar(
                    onTap: onTabTapped,
                    currentIndex: _currentIndex,
                    type: BottomNavigationBarType.fixed,
                    selectedFontSize: 32.0,
                    unselectedFontSize: 24.0,
                    backgroundColor: darkGrey,
                    items: [
                      BottomNavigationBarItem(
                        backgroundColor: darkGrey,
                        icon: Text(
                          "Scheduled Requests",
                          style: smallAddressWhite2SansRegular(),
                        ),
                        title: Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Image.asset(
                            "lib/assets/icon/today.png",
                            height: 25.0,
                            width: 25.0,
                          ),
//                      Text(dateNow, style: subTitleWhiteSR()),
                        ),
                      ),
                      BottomNavigationBarItem(
                        backgroundColor: darkGrey,
                        icon: Text(
                          "Scheduled Meetings",
                          style: smallAddressWhite2SansRegular(),
                        ),
                        title: Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Image.asset(
                            "lib/assets/icon/completed.png",
                            height: 25.0,
                            width: 25.0,
                            color: Colors.white70,
                          ),
//                      Text("2/10", style: subTitleWhiteSR()),
                        ),
                      )
                    ],
                  ),
                ),
                // _children[_currentIndex],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
