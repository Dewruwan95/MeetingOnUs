import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:meetingonus/screens/home/dashboard.dart' as myDashboard;
import 'package:meetingonus/screens/home/drawer.dart';
import 'package:meetingonus/style/style.dart';
import 'package:meetingonus/style/style.dart' as prefix0;

final FirebaseAuth auth = FirebaseAuth.instance;
final databaseReference = FirebaseDatabase.instance.reference();
CollectionReference users = FirebaseFirestore.instance.collection('users');


class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: prefix0.bgGrey,
        drawer: MyDrawer(),
        appBar: AppBar(
          elevation: 0.0,
          title: Text(
            "Profile",
            style: subBoldTitleWhite(),
          ),
          iconTheme: IconThemeData(color: Colors.white),
        ),
        body: ListView(
          padding: EdgeInsets.all(20.0),
          children: <Widget>[
            Container(
              height: 130.0,
              child: Stack(
                alignment: AlignmentDirectional.center,
                children: <Widget>[
                  CircleAvatar(
                    radius: 50.0,
                    backgroundColor: primary.withOpacity(0.4),
                    child: myDashboard.globalUser.createProfileImage(),
                  ),
                  Positioned(
                    right: prefix0.screenWidth(context) / 3.4,
                    top: prefix0.screenHeight(context) / 9,
                    child: Container(
                      height: 30.0,
                      width: 30.0,
                      child: new FloatingActionButton(
                        foregroundColor: Colors.black,
                        backgroundColor: Colors.white,
                        onPressed: () {
                          // ------------------------ on will popup---------------------
                        },
                        tooltip: 'Photo',
                        child: new Icon(
                          Icons.camera_alt,
                          size: 14.0,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Container(
              height: 70.0,
              margin: EdgeInsets.only(top: 20.0, bottom: 14.0),
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
                  InkWell(
                    onTap: () {
                      //--------------- on will popup -------------------------
                    },
                    child: CircleAvatar(
                      radius: 22.0,
                      backgroundColor: primary.withOpacity(0.4),
                      child: myDashboard.globalUser.createProfileImage(),
                    ),
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
            InkWell(
              onTap: () {
                // Navigator.of(context).pushNamed(PriorityTask.tag);-------------------------------
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
                          "lib/assets/icon/timeline.png",
                          height: 22.0,
                          width: 22.0,
                        )),
                        Text(
                          "Schedule List",
                          style: textSmallStyleGreySS(),
                        ),
                      ],
                    ),
                    IconButton(
                        icon: Image.asset(
                      "lib/assets/icon/arrow.png",
                      height: 22.0,
                      width: 22.0,
                    )),
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {
                //Navigator.of(context).pushNamed(TaskList.tag);---------------------------------------
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
                        )),
                        Text(
                          "Schedule History",
                          style: textSmallStyleGreySS(),
                        ),
                      ],
                    ),
                    IconButton(
                        icon: Image.asset(
                      "lib/assets/icon/arrow.png",
                      height: 22.0,
                      width: 22.0,
                    )),
                  ],
                ),
              ),
            ),
//          InkWell(
//            onTap: (){
//              Navigator.of(context).pushNamed(ContactUs.tag);
//            },
//            child: Container(
//              height: 70.0,
//              width: screenHeight(context),
//              padding: EdgeInsets.all(8.0),
//              margin: EdgeInsets.only(bottom: 14.0),
//              decoration: new BoxDecoration(
//                color: Colors.white,
//                boxShadow: [
//                  new BoxShadow(
//                    color: Colors.grey.shade300,
//                    blurRadius: 8.0,
//                  ),
//                ],
//              ),
//              child: Row(
//                children: <Widget>[
//                  IconButton(icon: Image.asset("lib/assets/icon/help.png", height: 22.0, width: 22.0, color: Colors.black,)),
//                  Text("Help", style: textSmallStyleGreySS(),),
//                ],
//              ),
//            ),
//          ),
          ],
        ));
  }
}
