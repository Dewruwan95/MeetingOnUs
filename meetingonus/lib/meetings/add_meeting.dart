import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:meetingonus/screens/home/dashboard.dart' as myDashboard;
import 'package:meetingonus/style/style.dart';
import 'package:meetingonus/style/style.dart' as prefix0;

class AddMeeting extends StatefulWidget {
  @override
  _AddMeetingState createState() => _AddMeetingState();
}

final CollectionReference meetings =
    FirebaseFirestore.instance.collection('Meetings');

class _AddMeetingState extends State<AddMeeting> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final TextEditingController _meetingTitleController = TextEditingController();
  final TextEditingController _meetingNoteController = TextEditingController();
  DateTime pickedDate;
  TimeOfDay pickedTime;
  bool loading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pickedDate = DateTime.now();
    pickedTime = TimeOfDay.now();
  }

//--------------------------------- schedule meeting ---------------------
  Future<void> _scheduleMeeting() async {
    setState(() {
      loading = true;
    });

    _addMeetingToCloud();
    await Future.delayed(const Duration(seconds: 2), () {
      showInSnackBar('Your meeting scheduled successfully');
    });

    setState(() {
      loading = false;
    });

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => myDashboard.Dashboard(),
      ),
    );
  }

  //-------------------------------- add data to firebase ----------------------------------
  Future<void> _addMeetingToCloud() {
    return meetings
        .add({
          'user_id': myDashboard.globalUser.getUserId(),
          'user_name': myDashboard.globalUser.getUserName(),
          'user_email': myDashboard.globalUser.getUserEmail(),
          'meeting_title': _meetingTitleController.text,
          'meeting_note': _meetingNoteController.text,
          'schedule_date': pickedDate,
          'schedule_time': "${pickedTime.hour}:${pickedTime.minute}",
          'schedule_status': 'pending',
        })
        .then((value) => print("Your meeting scheduled successfully"))
        .catchError((error) => print("Failed to add user: $error"));
  }

//------------------------------------- start build function -------------------------------
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
                                      'SCHEDULE',
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
                                  _scheduleMeeting();
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
}
