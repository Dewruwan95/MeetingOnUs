import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:meetingonus/screens/authentication/login.dart';
import 'package:meetingonus/style/style.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class PasswordReset extends StatefulWidget {
  @override
  _PasswordResetState createState() => _PasswordResetState();
}

class _PasswordResetState extends State<PasswordReset> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  bool loading = false;

  //-++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ User Password Reset Function +++++++++++++++++++++++++++++++++++++++++

  void _passwordReset() async {
    setState(() {
      loading = true;
    });
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    try {
      await _auth.sendPasswordResetEmail(email: _emailController.text);
      showInSnackBar(
          'A Password Reset Link has been Sent to ${_emailController.text}');
      setState(() {
        loading = false;
      });
     // Navigator.of(context).push(_createRoute());
    } catch (e) {
      showInSnackBar(
          'Incorrect Email or Your Connection Problem! Please Try Again.');
      setState(() {
        loading = false;
      });
    }
  }

//----------------------------------------------------- build snack bar ------------------------------
  void showInSnackBar(String value) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(
        value,
        textAlign: TextAlign.center,
      ),
      duration: Duration(seconds: 3),
    ));
  }

  // //----------------------- navigation animation ------------------------
  // Route _createRoute() {
  //   return PageRouteBuilder(
  //     pageBuilder: (context, animation, secondaryAnimation) => Login(),
  //     transitionsBuilder: (context, animation, secondaryAnimation, child) {
  //       var begin = Offset(0.0, 1.0);
  //       var end = Offset.zero;
  //       var curve = Curves.fastOutSlowIn;
  //
  //       var tween =
  //           Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
  //
  //       return SlideTransition(
  //         position: animation.drive(tween),
  //         child: child,
  //       );
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      key: _scaffoldKey,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: Stack(
          // alignment: AlignmentDirectional.center,
          fit: StackFit.expand,
          children: <Widget>[
            new Image(
              image: new AssetImage("lib/assets/bg/background.png"),
              fit: BoxFit.cover,
            ),
            Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(30.0, 0.0, 30.0, 30.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Image(
                      image: AssetImage("lib/assets/icon/logowithtext.png"),
                    ),
                    Container(
                      alignment: AlignmentDirectional.center,
                      padding: EdgeInsets.fromLTRB(0.0, 40.0, 0.0, 30.0),
                      child: Text(
                        "Enter your Email Address, password Reset link will send to your email address",
                        style: subTitleWhite2(),
                        textAlign: TextAlign.center,
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
                              padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 15.0),
                              child: Stack(
                                children: <Widget>[
                                  Container(
                                    width: screenWidth(context) * 0.83,
                                    color: Colors.white,
                                    padding: EdgeInsets.only(left: 65.0),
                                    child: TextFormField(
                                      textAlign: TextAlign.left,
                                      cursorColor: border,
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: 'Email Address',
                                        hintStyle: hintStyleDark(),
                                      ),
                                      style: hintStyleDark(),
                                      keyboardType: TextInputType.emailAddress,
                                      validator: (value) => value.isEmpty
                                          ? 'Email cannot be empty'
                                          : !value.contains('@')
                                              ? 'Incorrect Email'
                                              : null,
                                      controller: _emailController,
                                      onSaved: (String value) {
                                        _emailController.text = value;
                                      },
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
                                            size: 18.0,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
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
                                    _passwordReset();
                                  }
                                },
                                splashColor: secondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
