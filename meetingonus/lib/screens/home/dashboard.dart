import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:meetingonus/style/style.dart';

final FirebaseAuth auth = FirebaseAuth.instance;
final databaseReference = FirebaseDatabase.instance.reference();
CollectionReference users = FirebaseFirestore.instance.collection('users');
var userName = " ";
String userStateText = '';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  String dateNow = DateFormat('d MMM yyyy').format(DateTime.now());
  int _currentIndex = 0;

  //--------------------------- get lecturer status from firebase realtime database --------------
  void readData() {
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

//---------------------- get user details from firebase----------------

  void inputData() {
    final User user = auth.currentUser;
    final uid = user.uid;

    users.doc(uid).snapshots().listen((event) {
      userName = event.data()["user_name"];
    });
  }

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
  void initState() {
    // TODO: implement initState
    super.initState();
    inputData();
    readData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: appBarTitle,
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: primary,
        actions: [],
      ),
      drawer: Drawer(),
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
                  'Dear ' + userName + ', ' + userStateText,
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
                        "Schedule Requests",
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
    );
  }
}
