import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:meetingonus/screens/home/dashboard.dart' as myDashboard;
import 'package:meetingonus/style/style.dart';

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
  void _scheduleMeeting() {
    setState(() {
      loading = true;
    });

    _addMeetingToCloud();
    setState(() {
      loading = true;
    });
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
          'schedule_time': pickedTime,
        })
        .then((value) => print("Your meeting scheduled successfully"))
        .catchError((error) => print("Failed to add user: $error"));
  }

//------------------------------------- start build function -------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          "Add New Task",
          style: titleStyleBoldLight(),
        ),
        backgroundColor: primary,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
        bottomOpacity: 0.0,
        elevation: 0.0,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close, color: Colors.black87, size: 22.0),
              onPressed: () {
                Navigator.of(context).pop();
              }),
        ],
      ),
      backgroundColor: Colors.white,
      body: Container(
        child: Column(
          children: [
            SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: ListView(
                  shrinkWrap: true,
                  physics: ScrollPhysics(),
                  children: [
                    Container(
                      padding:
                          EdgeInsetsDirectional.only(start: 10.0, end: 10.0),
                      child: TextFormField(
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Meeting Title',
                          hintStyle: hintStyleDark(),
                        ),
                        keyboardType: TextInputType.text,
                        style: titleStyleBoldLight(),
                        onSaved: (value) {
                          _meetingTitleController.text = value;
                        },
                        controller: _meetingTitleController,
                        cursorColor: border,
                        validator: (String value) {
                          if (value.isEmpty) {
                            return 'Please enter a meeting title';
                          } else {
                            return '';
                          }
                        },
                      ),
                    ),
                    Divider(
                      color: Colors.grey.shade500,
                      height: 10.0,
                    ),
                    Container(
                      padding: EdgeInsetsDirectional.only(start: 10.0),
                      child: TextFormField(
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Meeting Note',
                          hintStyle: hintStyleDark(),
                        ),
                        maxLength: 100,
                        keyboardType: TextInputType.text,
                        style: titleStyleBoldLight(),
                        onSaved: (value) {
                          _meetingNoteController.text = value;
                        },
                        controller: _meetingNoteController,
                        cursorColor: border,
                        validator: (String value) {
                          if (value.isEmpty) {
                            return 'Please enter a meeting title';
                          } else {
                            return '';
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Divider(
              color: Colors.grey.shade500,
              height: 10.0,
            ),
            ListTile(
              title: Text(
                "Schedule Date :          ${pickedDate.year} - ${pickedDate.month} - ${pickedDate.day}",
              ),
              trailing: Icon(
                Icons.calendar_today_outlined,
                size: 27.0,
              ),
              onTap: _pickDate,
            ),
            Divider(
              color: Colors.grey.shade500,
              height: 10.0,
            ),
            ListTile(
              title: Text(
                  "Schedule Time :          ${pickedTime.hour} : ${pickedTime.minute}"),
              trailing: Icon(
                Icons.access_time_outlined,
                size: 30.0,
              ),
              onTap: _pickTime,
            ),
            Padding(
              padding: EdgeInsetsDirectional.only(
                  top: 80.0, start: 60.0, end: 60.0, bottom: 10.0),
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
                        padding: new EdgeInsets.only(left: 5.0, right: 5.0),
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
                    print('Schedule button clicked');
                    //_scheduleMeeting();
                  }
                },
                splashColor: secondary,
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
