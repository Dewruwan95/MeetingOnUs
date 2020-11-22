import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:meetingonus/screens/home/dashboard.dart' as myDashboard;
import 'package:meetingonus/style/style.dart';
import 'package:meetingonus/style/style.dart' as prefix0;

class Help extends StatefulWidget {
  @override
  _HelpState createState() => _HelpState();
}

final CollectionReference userMessages =
    FirebaseFirestore.instance.collection('UserMessages');

class _HelpState extends State<Help> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  bool loading = false;

  final TextEditingController _nameControllerHelp = TextEditingController();
  final TextEditingController _emailControllerHelp = TextEditingController();
  final TextEditingController _subjectControllerHelp = TextEditingController();
  final TextEditingController _messageControllerHelp = TextEditingController();

  void setUserDetails() {
    _nameControllerHelp.text = myDashboard.globalUser.getUserName();
    _emailControllerHelp.text = myDashboard.globalUser.getUserEmail();
  }

  @override
  void initState() {
    super.initState();
    setUserDetails();
  }

  //----------------------- navigation animation for Dashboard ------------------------
  Route _navigateToDashboard() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => myDashboard.Dashboard(),
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

//------------------------------- send data to firestore function ---------------------------------------
  Future<void> addMessageToCloud(var id) {
    // Call the user's CollectionReference to add a new user
    return userMessages
        .doc(id)
        .set({
          'user_name': _nameControllerHelp.text,
          'email': _emailControllerHelp.text,
          'subject': _subjectControllerHelp.text,
          'message': _messageControllerHelp.text,
        })
        .then((value) =>
            print("Your message sent successfully"))
        .catchError((error) => print("Failed to add user: $error"));
  }

//---------------------- clear controller -------------------------------------
  void _clearController() {
    _subjectControllerHelp.text = "";
    _messageControllerHelp.text = "";
  }

  //-++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ send User Message Function +++++++++++++++++++++++++++++++++++++++++

  void _sendUserMessage() async {
    setState(() {
      loading = true;
    });
    addMessageToCloud(myDashboard.globalUser.getUserId());
    showInSnackBar('Your message sent successfully, Our support team will contact you');
    _clearController();
    setState(() {
      loading = false;
    });
  }

  void showInSnackBar(String value) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(
        value,
        textAlign: TextAlign.center,
      ),
      duration: Duration(seconds: 3),
    ));
  }

  //---------------------------------------- Start Build Function --------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      key: _scaffoldKey,
      appBar: AppBar(
          title: Text(
            "Contact Us",
            style: subBoldTitleWhite(),
          ),
          iconTheme: IconThemeData(color: Colors.white),
          elevation: 0.0,
          backgroundColor: primary,
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.home,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.of(context).push(_navigateToDashboard());
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
                  Container(
                    padding: EdgeInsets.fromLTRB(30.0, 40.0, 30.0, 0.0),
                    child: Image(
                      image: AssetImage("lib/assets/icon/logowithtext.png"),
                      height: 70,
                    ),
                  ),
                  Container(
                    width: prefix0.screenWidth(context) * 0.8,
                    padding: EdgeInsets.fromLTRB(30.0, 40.0, 0.0, 30.0),
                    child: Text(
                      "If you're facing any kind of problem, reach out us at",
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
                                      hintText: 'User Name',
                                      hintStyle: hintStyleDark(),
                                    ),
                                    style: hintStyleDark(),
                                    keyboardType: TextInputType.text,
                                    validator: (String value) => value.isEmpty
                                        ? 'User Name cannot be empty'
                                        : null,
                                    onSaved: (String value) {
                                      _nameControllerHelp.text = value;
                                    },
                                    controller: _nameControllerHelp,
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
                                          FontAwesomeIcons.user,
                                          color: Colors.white,
                                          size: 16.0,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
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
                                      hintText: 'Email',
                                      hintStyle: hintStyleDark(),
                                    ),
                                    style: hintStyleDark(),
                                    keyboardType: TextInputType.emailAddress,
                                    validator: (value) => value.isEmpty
                                        ? 'Email cannot be empty'
                                        : !value.contains('@')
                                            ? 'Incorrect Email'
                                            : null,
                                    onSaved: (String value) {
                                      _emailControllerHelp.text = value;
                                    },
                                    controller: _emailControllerHelp,
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
                                          Icons.mail,
                                          color: Colors.white,
                                          size: 16.0,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
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
                                    decoration: new InputDecoration(
                                      border: InputBorder.none,
                                      hintText: 'Subject',
                                      hintStyle: hintStyleDark(),
                                    ),
                                    keyboardType: TextInputType.text,
                                    style: hintStyleDark(),
                                    validator: (String value) => value.isEmpty
                                        ? 'Please give a subject for message'
                                        : null,
                                    onSaved: (String value) {
                                      _subjectControllerHelp.text = value;
                                    },
                                    controller: _subjectControllerHelp,
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
                                          Icons.subject,
                                          color: Colors.white,
                                          size: 18.0,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
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
                                      hintText: 'Message',
                                      hintStyle: hintStyleDark(),
                                    ),
                                    maxLines: 5,
                                    style: hintStyleDark(),
                                    keyboardType: TextInputType.text,
                                    validator: (String value) => value.isEmpty
                                        ? 'Please leave your message'
                                        : null,
                                    onSaved: (String value) {
                                      _messageControllerHelp.text = value;
                                    },
                                    controller: _messageControllerHelp,
                                  ),
                                ),
                              ],
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
                                      'SUBMIT',
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
                                  _sendUserMessage();
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
