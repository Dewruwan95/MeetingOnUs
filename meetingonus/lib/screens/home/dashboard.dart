import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:meetingonus/meetings/add_meeting.dart';
import 'package:meetingonus/screens/authentication/login.dart';
import 'package:meetingonus/screens/home/drawer.dart';
import 'package:meetingonus/style/style.dart';
import 'package:meetingonus/style/style.dart' as prefix0;
import 'package:meetingonus/service/user_service.dart' as myUser;
import 'package:splashscreen/splashscreen.dart';

final FirebaseAuth auth = FirebaseAuth.instance;
final databaseReference = FirebaseDatabase.instance.reference();
CollectionReference users = FirebaseFirestore.instance.collection('users');
var selectedMeetingId;

String userStateText = '';

myUser.MyUser globalUser;

bool pushNotificationValue = false;

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  CollectionReference meetings =
      FirebaseFirestore.instance.collection('Meetings');
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

  Future<void> createGlobalUser() async {
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
  Future<void> getLecturerStatus() async{
    databaseReference.child('UserStatus').onValue.listen((event) {
      var snapshot = event.snapshot;
      setState(() {
        String value = snapshot.value['CurrentStatus'];
        if (value == 'active') {
          userStateText = 'Lecturer in the room now';
        } else if (value == 'deactive') {
          userStateText = 'Lecturer not in the room now';
        }else{
          userStateText = 'Loading Data ...';
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
      ),
    );
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
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  final db = FirebaseFirestore.instance;

  Stream meetingRequests = FirebaseFirestore.instance
      .collection('Meetings')
      .where('user_id', isEqualTo: userAuthenticationFromLoginGlobalId)
      .where('schedule_status', isEqualTo: 'pending')
      .snapshots();

  //------------------------------------------- re schedule meeting -------------------------------
  void _reScheduleMeeting(var meetingId) {
    selectedMeetingId = meetingId;

    Navigator.of(context).push(_navigateToEditMeeting());
  }

  //----------------------- navigation animation for edit meeting ------------------------
  Route _navigateToEditMeeting() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => EditMeeting(),
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

//=============================================================================================================================================
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
            height: 700,
            child: ListView(
              scrollDirection: Axis.vertical,
              children: snapshot.data.documents.map<Widget>((doc) {
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
                                  "${DateFormat.MMMd().format(doc['schedule_date'].toDate())}",
                                  style: textStyleOrangeSS(),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 4.0),
                                  child: Text(
                                    "${doc['schedule_time']}",
                                    style: subTitleDarkSS(),
                                  ),
                                ),
                              ],
                            ),
                            title: Text(
                              "${doc['meeting_title']}",
                              style: subTitle(),
                            ),
                            subtitle: Text(
                              "${doc['user_name']}",
                              style: smallAddressSS(),
                            ),
                          ),
                        ),
                        actions: <Widget>[
                          Container(
                            color: orange,
                            child: InkWell(
                              onTap: () async {
                                await db
                                    .collection('Meetings')
                                    .doc(doc.documentID)
                                    .update({'schedule_status': 'confirmed'});

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        Dashboard(),
                                  ),
                                );
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
                                _reScheduleMeeting(doc.documentID);
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
                                onTap: () async {
                                  await db
                                      .collection('Meetings')
                                      .doc(doc.documentID)
                                      .delete();

                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          Dashboard(),
                                    ),
                                  );
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
  final db = FirebaseFirestore.instance;
  Stream meetingConfirmed = FirebaseFirestore.instance
      .collection('Meetings')
      .where('schedule_status', isEqualTo: 'confirmed')
      .where('user_id', isEqualTo: globalUser.getUserId())
      .snapshots();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

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
            height: 700,
            child: ListView(
              scrollDirection: Axis.vertical,
              children: snapshot.data.documents.map<Widget>((doc) {
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
                                  "${DateFormat.MMMd().format(doc['schedule_date'].toDate())}",
                                  style: textStyleOrangeSS(),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 4.0),
                                  child: Text(
                                    "${doc['schedule_time']}",
                                    style: subTitleDarkSS(),
                                  ),
                                ),
                              ],
                            ),
                            title: Text(
                              "${doc['meeting_title']}",
                              style: subTitle(),
                            ),
                            subtitle: Text(
                              "${doc['user_name']}",
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
                                onTap: () async {
                                  await db
                                      .collection('Meetings')
                                      .doc(doc.documentID)
                                      .delete();

                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          Dashboard(),
                                    ),
                                  );
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

//===============================================================================================================================================================
class EditMeeting extends StatefulWidget {
  @override
  _EditMeetingState createState() => _EditMeetingState();
}

class _EditMeetingState extends State<EditMeeting> {
  CollectionReference scheduledMeetings =
      FirebaseFirestore.instance.collection('Meetings');

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final TextEditingController _meetingTitleController = TextEditingController();
  final TextEditingController _meetingNoteController = TextEditingController();
  DateTime pickedDate;
  TimeOfDay pickedTime;
  bool loading = false;

  //-------------------- get meeting details --------------------------------\
  Future<void> getMeetingDetails() {
    scheduledMeetings.doc(selectedMeetingId).snapshots().listen((event) {
      _meetingTitleController.text = event.data()["meeting_title"];
      _meetingNoteController.text = event.data()["meeting_note"];
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getMeetingDetails();

    pickedDate = DateTime.now();
    pickedTime = TimeOfDay.now();
  }

  //--------------------------- create date picker -----------------------
  void _pickDate() async {
    DateTime date = await showDatePicker(
      context: context,
      firstDate: DateTime(DateTime.now().year - 1),
      lastDate: DateTime(DateTime.now().year + 1),
      initialDate: pickedDate,
    );

    if (date != null) {
      setState(() {
        pickedDate = date;
      });
    }
  }

//----------------------------- create time picker ----------------------------
  void _pickTime() async {
    TimeOfDay time = await showTimePicker(
      context: context,
      initialTime: pickedTime,
    );

    if (time != null) {
      setState(() {
        pickedTime = time;
      });
    }
  }

  //----------------------------- show snack bar -----------------------------------
  void showInSnackBar(String value) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(
        value,
        textAlign: TextAlign.center,
      ),
      duration: Duration(seconds: 3),
    ));
  }

  //-------------------------------- update meeting cloud ----------------------------------
  Future<void> _updateMeetingToCloud() {
    return meetings
        .doc(selectedMeetingId)
        .update({
          'user_id': globalUser.getUserId(),
          'user_name': globalUser.getUserName(),
          'user_email': globalUser.getUserEmail(),
          'meeting_title': _meetingTitleController.text,
          'meeting_note': _meetingNoteController.text,
          'schedule_date': pickedDate,
          'schedule_time': "${pickedTime.hour}:${pickedTime.minute}",
          'schedule_status': 'pending',
        })
        .then((value) => print("Your meeting scheduled successfully"))
        .catchError((error) => print("Failed to add user: $error"));
  }

//--------------------------------- schedule meeting ---------------------
  Future<void> _updateScheduleMeeting() async {
    setState(() {
      loading = true;
    });

    _updateMeetingToCloud();
    await Future.delayed(const Duration(seconds: 2), () {
      showInSnackBar('Your meeting updated successfully');
    });

    setState(() {
      loading = false;
    });

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => Dashboard(),
      ),
    );
  }

  //---------------------------------------------------------------------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      key: _scaffoldKey,
      appBar: AppBar(
          title: Text(
            "Schedule New Meeting",
            style: subBoldTitleWhite(),
          ),
          iconTheme: IconThemeData(color: Colors.white),
          elevation: 0.0,
          backgroundColor: primary,
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.close,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ]),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: Stack(
          alignment: AlignmentDirectional.center,
          fit: StackFit.expand,
          children: <Widget>[
            new Image(
              image: new AssetImage("lib/assets/bg/background.png"),
              fit: BoxFit.cover,
            ),
            SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // Container(
                  //   padding: EdgeInsets.fromLTRB(30.0, 40.0, 30.0, 0.0),
                  //   child: Image(
                  //     image: AssetImage("lib/assets/icon/logowithtext.png"),
                  //     height: 70,
                  //   ),
                  // ),
                  Container(
                    width: prefix0.screenWidth(context) * 0.8,
                    padding: EdgeInsets.fromLTRB(30.0, 40.0, 0.0, 30.0),
                    child: Text(
                      "Please type a meeting title and briefly describe your situation",
                      style: subTitleWhite2SansRegular(),
                      textAlign: TextAlign.justify,
                    ),
                  ),
                  Form(
                    key: _formKey,
                    child: Theme(
                      data: ThemeData(
                        brightness: Brightness.dark,
                        accentColor: primary,
                        inputDecorationTheme: new InputDecorationTheme(
                          labelStyle: new TextStyle(
                            color: primary,
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.fromLTRB(30.0, 0.0, 30.0, 15.0),
                            child: Stack(
                              children: <Widget>[
                                Container(
                                  width: screenWidth(context) * 0.83,
                                  color: Colors.white,
                                  padding: EdgeInsets.only(left: 65.0),
                                  child: TextFormField(
                                    cursorColor: border,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: 'Meeting Title',
                                      hintStyle: hintStyleDark(),
                                    ),
                                    style: hintStyleDark(),
                                    keyboardType: TextInputType.text,
                                    validator: (String value) => value.isEmpty
                                        ? 'Meeting title cannot be empty'
                                        : null,
                                    onSaved: (String value) {
                                      _meetingTitleController.text = value;
                                    },
                                    controller: _meetingTitleController,
                                  ),
                                ),
                                Positioned(
                                  top: -18.0,
                                  left: -8.0,
                                  right: (screenWidth(context) * 0.83) - 55.0,
                                  child: Stack(
                                    fit: StackFit.loose,
                                    alignment: AlignmentDirectional.center,
                                    children: <Widget>[
                                      Image.asset(
                                        "lib/assets/icon/sendicon.png",
                                        fit: BoxFit.fitHeight,
                                        height: 85,
                                        width: 85,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            bottom: 4.0, left: 0.0),
                                        child: Icon(
                                          Icons.notes_sharp,
                                          color: Colors.white,
                                          size: 16.0,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: prefix0.screenWidth(context) * 0.83,
                            padding: EdgeInsets.only(bottom: 15.0),
                            child: Stack(
                              children: <Widget>[
                                Container(
                                  color: Colors.white,
                                  padding: EdgeInsets.only(left: 12.0),
                                  child: TextFormField(
                                    cursorColor: border,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: 'Meeting Note',
                                      hintStyle: hintStyleDark(),
                                    ),
                                    maxLines: 5,
                                    style: hintStyleDark(),
                                    keyboardType: TextInputType.text,
                                    validator: (String value) => value.isEmpty
                                        ? 'Please write a small note'
                                        : null,
                                    onSaved: (String value) {
                                      _meetingNoteController.text = value;
                                    },
                                    controller: _meetingNoteController,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.only(
                                top: 5.0, start: 35.0, end: 35.0, bottom: 10.0),
                            child: ListTile(
                              tileColor: Colors.white,
                              title: Text(
                                "Schedule Date :  ${pickedDate.year} - ${pickedDate.month} - ${pickedDate.day}",
                                style: hintStyleDark(),
                              ),
                              trailing: Icon(
                                Icons.calendar_today_outlined,
                                size: 27.0,
                                color: Colors.black54,
                              ),
                              onTap: _pickDate,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.only(
                                top: 5.0, start: 35.0, end: 35.0, bottom: 10.0),
                            child: ListTile(
                              tileColor: Colors.white,
                              title: Text(
                                "Schedule Time :  ${pickedTime.hour} : ${pickedTime.minute}",
                                style: hintStyleDark(),
                              ),
                              trailing: Icon(
                                Icons.access_time_outlined,
                                size: 30.0,
                                color: Colors.black54,
                              ),
                              onTap: _pickTime,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.only(
                                top: 30.0,
                                start: 45.0,
                                end: 45.0,
                                bottom: 10.0),
                            child: RawMaterialButton(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              fillColor: secondary,
                              child: Container(
                                height: 45.0,
                                width: screenWidth(context) * 0.5,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      'UPDATE',
                                      style: subTitleWhiteSansRegular(),
                                    ),
                                    new Padding(
                                      padding: new EdgeInsets.only(
                                          left: 5.0, right: 5.0),
                                    ),
                                    loading == true
                                        ? new Image.asset(
                                            'lib/assets/gif/load.gif',
                                            width: 19.0,
                                            height: 19.0,
                                          )
                                        : new Text(''),
                                  ],
                                ),
                              ),
                              onPressed: () {
                                if (_formKey.currentState.validate()) {
                                  _updateScheduleMeeting();
                                }
                              },
                              splashColor: secondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
