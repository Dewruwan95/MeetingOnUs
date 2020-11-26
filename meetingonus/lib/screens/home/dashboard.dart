import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:meetingonus/meetings/add_meeting.dart';
import 'package:meetingonus/screens/home/drawer.dart';
import 'package:meetingonus/style/style.dart';
import 'package:meetingonus/style/style.dart' as prefix0;
import 'package:meetingonus/service/user_service.dart' as myUser;
import 'package:splashscreen/splashscreen.dart';

final FirebaseAuth auth = FirebaseAuth.instance;
final databaseReference = FirebaseDatabase.instance.reference();
CollectionReference users = FirebaseFirestore.instance.collection('users');

Stream meetingConfirmed = FirebaseFirestore.instance.collection('Meetings').where('schedule_status',isEqualTo: 'confirmed').snapshots();

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

  final List<Widget> _children = [
    MeetingInProgress(),
    MeetingCompleted(),
  ];

  @override
  void initState() {
    // TODO: implement initState
    MySplashScreenToDashboard();
    super.initState();
    inputData();
    getLecturerStatus();
  }

  void createGlobalUser() {
    globalUser = currentUser;
  }

  //----------------------------- list meeting  -----------------------------
  // Widget _meetingList() {
  //   return StreamBuilder(
  //     stream: meetingRequests,
  //     builder: (context, snapshot) {
  //       if (!snapshot.hasData) {
  //         return Center(
  //           child: CircularProgressIndicator(),
  //         );
  //       } else {
  //         return SizedBox(
  //           height: 600,
  //           child: ListView(
  //             scrollDirection: Axis.vertical,
  //             children: snapshot.data.documents.map<Widget>((document) {
  //               return Column(
  //                 children: <Widget>[
  //                   Divider(
  //                     height: 10.0,
  //                     color: prefix0.bgGrey,
  //                   ),
  //                   InkWell(
  //                     onTap: () {
  //                       //--------------------------------------------------------------------
  //                     },
  //                     child: Slidable(
  //                       actionPane: SlidableDrawerActionPane(),
  //                       actionExtentRatio: 0.3,
  //                       child: Container(
  //                         alignment: AlignmentDirectional.center,
  //                         height: 80.0,
  //                         color: Colors.white,
  //                         child: ListTile(
  //                           leading: Column(
  //                             mainAxisAlignment: MainAxisAlignment.center,
  //                             crossAxisAlignment: CrossAxisAlignment.center,
  //                             children: <Widget>[
  //                               Text(
  //                                 "${DateFormat.MMMd().format(
  //                                     document['schedule_date'].toDate())}",
  //                                 style: textStyleOrangeSS(),
  //                               ),
  //                               Padding(
  //                                 padding: const EdgeInsets.only(top: 4.0),
  //                                 child: Text(
  //                                   "${document['schedule_time']}",
  //                                   style: subTitleDarkSS(),
  //                                 ),
  //                               ),
  //                             ],
  //                           ),
  //                           title: Text(
  //                             "${document['meeting_title']}",
  //                             style: subTitle(),
  //                           ),
  //                           subtitle: Text(
  //                             "${document['user_name']}",
  //                             style: smallAddressSS(),
  //                           ),
  //                         ),
  //                       ),
  //                       actions: <Widget>[
  //                         Container(
  //                           color: orange,
  //                           child: InkWell(
  //                             onTap: () {
  //                               setState(() {
  //                                 //taskCompleted = true;
  //                               });
  //                               // crudObj.updateData(snapshot.data.documents[index].documentID, loginType == 'fs' ? uid : loginType == 'fb' ? fbId : twId, {
  //                               //   'completed': this.taskCompleted,
  //                               // });
  //                             },
  //                             child: Column(
  //                               mainAxisAlignment: MainAxisAlignment.center,
  //                               crossAxisAlignment: CrossAxisAlignment.center,
  //                               children: <Widget>[
  //                                 Image.asset("lib/assets/icon/checked.png"),
  //                                 Padding(
  //                                   padding: const EdgeInsets.only(top: 7.0),
  //                                   child: Text(
  //                                     "Confirm",
  //                                     style: subTitleWhite2SansRegular(),
  //                                   ),
  //                                 ),
  //                               ],
  //                             ),
  //                           ),
  //                         ),
  //                       ],
  //                       secondaryActions: <Widget>[
  //                         Container(
  //                           color: primary,
  //                           child: InkWell(
  //                             onTap: () {
  //                               //--------------------------------------------------------------------------------------------
  //                             },
  //                             child: Column(
  //                               mainAxisAlignment: MainAxisAlignment.center,
  //                               crossAxisAlignment: CrossAxisAlignment.center,
  //                               children: <Widget>[
  //                                 Icon(FontAwesomeIcons.pencilAlt,
  //                                     size: 18.0, color: Colors.white),
  //                                 Padding(
  //                                   padding: const EdgeInsets.only(top: 7.0),
  //                                   child: Text(
  //                                     "Re Schedule",
  //                                     style: subTitleWhite2SansRegular(),
  //                                   ),
  //                                 ),
  //                               ],
  //                             ),
  //                           ),
  //                         ),
  //                         Container(
  //                           color: primary,
  //                           child: Center(
  //                             child: InkWell(
  //                               onTap: () {
  //                                 // crudObj.deleteData(snapshot.data.documents[index].documentID, loginType == 'fs' ? uid : loginType == 'fb' ? fbId : twId,);
  //                                 // Navigator.push(
  //                                 //   context,
  //                                 //   MaterialPageRoute(
  //                                 //     builder: (BuildContext context) => Landing(
  //                                 //     ),
  //                                 //   ),
  //                                 // );
  //                               },
  //                               child: Column(
  //                                 mainAxisAlignment: MainAxisAlignment.center,
  //                                 crossAxisAlignment: CrossAxisAlignment.center,
  //                                 children: <Widget>[
  //                                   Image.asset("lib/assets/icon/delete.png"),
  //                                   Padding(
  //                                     padding: const EdgeInsets.only(top: 2.0),
  //                                     child: Text(
  //                                       "Cancel",
  //                                       style: subTitleWhite2SansRegular(),
  //                                     ),
  //                                   ),
  //                                 ],
  //                               ),
  //                             ),
  //                           ),
  //                         ),
  //                       ],
  //                     ),
  //                   ),
  //                 ],
  //               )
  //               //   Center(
  //               //   child: Container(
  //               //     width: 70.0,
  //               //     height: 50.0,
  //               //     child: Text("Title :" + document['meeting_title']),
  //               //   ),
  //               // )
  //                   ;
  //             }).toList(),
  //           ),
  //         );
  //       }
  //     },
  //   );
  // }

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
    databaseReference
        .child('UserStatus')
        .onValue
        .listen((event) {
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

  //----------------------- navigation animation for add meeting ------------------------
  Route _navigateToAddMeeting() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => AddMeeting(),
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

  //---------------------------------------- start build function --------------------------
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
                    ),
                  )
                ],
              ),
            ),
                _children[_currentIndex],
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
            elevation: 6.0,
            child: Icon(
              Icons.add,
              color: Colors.white,
              size: 26.0,
            ),
            backgroundColor: secondary,
            mini: false,
            highlightElevation: 16.0,
            onPressed: () {
              Navigator.of(context).push(_navigateToAddMeeting());
            }),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      ),
    ),);
  }
}
//------------------------------------------------ end build--------------------------------
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++===++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//-------------------------------------- start  meeting in progress -------------------------------
class MeetingInProgress extends StatefulWidget {
  @override
  _MeetingInProgressState createState() => _MeetingInProgressState();
}

class _MeetingInProgressState extends State<MeetingInProgress> {

  Stream meetingRequests = FirebaseFirestore.instance.collection('Meetings').where('schedule_status',isEqualTo: 'pending').where('user_id', isEqualTo: globalUser.getUserId()).snapshots();
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: meetingRequests,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return SizedBox(
            height: 600,
            child: ListView(
              scrollDirection: Axis.vertical,
              children: snapshot.data.documents.map<Widget>((document) {
                return Column(
                  children: <Widget>[
                    Divider(
                      height: 10.0,
                      color: prefix0.bgGrey,
                    ),
                    InkWell(
                      onTap: () {
                        //--------------------------------------------------------------------
                      },
                      child: Slidable(
                        actionPane: SlidableDrawerActionPane(),
                        actionExtentRatio: 0.3,
                        child: Container(
                          alignment: AlignmentDirectional.center,
                          height: 80.0,
                          color: Colors.white,
                          child: ListTile(
                            leading: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  "${DateFormat.MMMd().format(
                                      document['schedule_date'].toDate())}",
                                  style: textStyleOrangeSS(),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 4.0),
                                  child: Text(
                                    "${document['schedule_time']}",
                                    style: subTitleDarkSS(),
                                  ),
                                ),
                              ],
                            ),
                            title: Text(
                              "${document['meeting_title']}",
                              style: subTitle(),
                            ),
                            subtitle: Text(
                              "${document['user_name']}",
                              style: smallAddressSS(),
                            ),
                          ),
                        ),
                        actions: <Widget>[
                          Container(
                            color: orange,
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  //taskCompleted = true;
                                });
                                // crudObj.updateData(snapshot.data.documents[index].documentID, loginType == 'fs' ? uid : loginType == 'fb' ? fbId : twId, {
                                //   'completed': this.taskCompleted,
                                // });
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Image.asset("lib/assets/icon/checked.png"),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 7.0),
                                    child: Text(
                                      "Confirm",
                                      style: subTitleWhite2SansRegular(),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                        secondaryActions: <Widget>[
                          Container(
                            color: primary,
                            child: InkWell(
                              onTap: () {
                                //--------------------------------------------------------------------------------------------
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Icon(FontAwesomeIcons.pencilAlt,
                                      size: 18.0, color: Colors.white),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 7.0),
                                    child: Text(
                                      "Re Schedule",
                                      style: subTitleWhite2SansRegular(),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            color: primary,
                            child: Center(
                              child: InkWell(
                                onTap: () {
                                  // crudObj.deleteData(snapshot.data.documents[index].documentID, loginType == 'fs' ? uid : loginType == 'fb' ? fbId : twId,);
                                  // Navigator.push(
                                  //   context,
                                  //   MaterialPageRoute(
                                  //     builder: (BuildContext context) => Landing(
                                  //     ),
                                  //   ),
                                  // );
                                },
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Image.asset("lib/assets/icon/delete.png"),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 2.0),
                                      child: Text(
                                        "Cancel",
                                        style: subTitleWhite2SansRegular(),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
                //   Center(
                //   child: Container(
                //     width: 70.0,
                //     height: 50.0,
                //     child: Text("Title :" + document['meeting_title']),
                //   ),
                // )
                    ;
              }).toList(),
            ),
          );
        }
      },
    );
  }
}

//-------------------------------------- end  meeting in progress -------------------------------
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//----------------------------- start meeting completed -------------------------------

class MeetingCompleted extends StatefulWidget {
  @override
  _MeetingCompletedState createState() => _MeetingCompletedState();
}

class _MeetingCompletedState extends State<MeetingCompleted> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: meetingConfirmed,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return SizedBox(
            height: 600,
            child: ListView(
              scrollDirection: Axis.vertical,
              children: snapshot.data.documents.map<Widget>((document) {
                return Column(
                  children: <Widget>[
                    Divider(
                      height: 10.0,
                      color: prefix0.bgGrey,
                    ),
                    InkWell(
                      onTap: () {
                        //--------------------------------------------------------------------
                      },
                      child: Slidable(
                        actionPane: SlidableDrawerActionPane(),
                        actionExtentRatio: 0.3,
                        child: Container(
                          alignment: AlignmentDirectional.center,
                          height: 80.0,
                          color: Colors.white,
                          child: ListTile(
                            leading: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  "${DateFormat.MMMd().format(
                                      document['schedule_date'].toDate())}",
                                  style: textStyleOrangeSS(),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 4.0),
                                  child: Text(
                                    "${document['schedule_time']}",
                                    style: subTitleDarkSS(),
                                  ),
                                ),
                              ],
                            ),
                            title: Text(
                              "${document['meeting_title']}",
                              style: subTitle(),
                            ),
                            subtitle: Text(
                              "${document['user_name']}",
                              style: smallAddressSS(),
                            ),
                          ),
                        ),
                        actions: <Widget>[
                          // Container(
                          //   color: orange,
                          //   child: InkWell(
                          //     onTap: () {
                          //       setState(() {
                          //         //taskCompleted = true;
                          //       });
                          //       // crudObj.updateData(snapshot.data.documents[index].documentID, loginType == 'fs' ? uid : loginType == 'fb' ? fbId : twId, {
                          //       //   'completed': this.taskCompleted,
                          //       // });
                          //     },
                          //     child: Column(
                          //       mainAxisAlignment: MainAxisAlignment.center,
                          //       crossAxisAlignment: CrossAxisAlignment.center,
                          //       children: <Widget>[
                          //         Image.asset("lib/assets/icon/checked.png"),
                          //         Padding(
                          //           padding: const EdgeInsets.only(top: 7.0),
                          //           child: Text(
                          //             "Confirm",
                          //             style: subTitleWhite2SansRegular(),
                          //           ),
                          //         ),
                          //       ],
                          //     ),
                          //   ),
                          // ),
                        ],
                        secondaryActions: <Widget>[
                          // Container(
                          //   color: primary,
                          //   child: InkWell(
                          //     onTap: () {
                          //       //--------------------------------------------------------------------------------------------
                          //     },
                          //     child: Column(
                          //       mainAxisAlignment: MainAxisAlignment.center,
                          //       crossAxisAlignment: CrossAxisAlignment.center,
                          //       children: <Widget>[
                          //         Icon(FontAwesomeIcons.pencilAlt,
                          //             size: 18.0, color: Colors.white),
                          //         Padding(
                          //           padding: const EdgeInsets.only(top: 7.0),
                          //           child: Text(
                          //             "Re Schedule",
                          //             style: subTitleWhite2SansRegular(),
                          //           ),
                          //         ),
                          //       ],
                          //     ),
                          //   ),
                          // ),
                          Container(
                            color: primary,
                            child: Center(
                              child: InkWell(
                                onTap: () {
                                  // crudObj.deleteData(snapshot.data.documents[index].documentID, loginType == 'fs' ? uid : loginType == 'fb' ? fbId : twId,);
                                  // Navigator.push(
                                  //   context,
                                  //   MaterialPageRoute(
                                  //     builder: (BuildContext context) => Landing(
                                  //     ),
                                  //   ),
                                  // );
                                },
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Image.asset("lib/assets/icon/delete.png"),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 2.0),
                                      child: Text(
                                        "Cancel",
                                        style: subTitleWhite2SansRegular(),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
                //   Center(
                //   child: Container(
                //     width: 70.0,
                //     height: 50.0,
                //     child: Text("Title :" + document['meeting_title']),
                //   ),
                // )
                    ;
              }).toList(),
            ),
          );
        }
      },
    );
  }
}
//----------------------------- end meeting completed -------------------------------

//----------------------------------- splash screen navigate to dashboard --------------------------------
class MySplashScreenToDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      seconds: 4,
      navigateAfterSeconds: Dashboard(),
      image: Image.asset(
        "lib/assets/bg/generallogo.png",
      ),
      backgroundColor: primary,
      photoSize: 140.0,
      loaderColor: secondary,
    );
  }
}
