import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:meetingonus/style/style.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool checkboxValue = true;
  bool loading = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  void onChangedCheckBoxValue(bool value) {
    setState(() {
      checkboxValue = value;
    });
  }

  bool _success; //to check user registration complete of not
  String _userEmail;

  //-++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ User Login Function +++++++++++++++++++++++++++++++++++++++++
  void _login() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    try {
      final User user = (await _auth.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      ))
          .user;

      showInSnackBar('Login Successful');
    } catch (e) {
      showInSnackBar('Login Failed! Please Try Again');
    }
  }

  //----------------------------------------------------- build snack bar ------------------------------
  void showInSnackBar(String value) {
    _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text(value,textAlign: TextAlign.center,),
          duration: Duration(seconds: 3),
        ));
  }

//------------------------------------------------------------ Common Alert Dialog ----------------------------------------

  AlertDialog _alertCommon(String myAlert) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              "Alert!",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            content: Text(myAlert),
            backgroundColor: primary,
            actions: [
              FlatButton(
                  child: Text("Close"),
                  color: secondary,
                  onPressed: () {
                    Navigator.of(context).pop();
                    _clear();
                  }),
            ],
          );
        });
  }

  //----------------------------------------------- Clear Controller Values ----------------------------------------
  void _clear() {
    _emailController.clear();
    _passwordController.clear();
  }

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
          alignment: AlignmentDirectional.center,
          fit: StackFit.expand,
          children: <Widget>[
            new Image(
              image: new AssetImage("lib/assets/bg/background.png"),
              fit: BoxFit.cover,
            ),
            Positioned(
              top: 40.0,
              child: Align(
                alignment: AlignmentDirectional.topStart,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.fromLTRB(30.0, 40.0, 0.0, 30.0),
                      child: Image(
                        image: AssetImage("lib/assets/icon/logowithtext.png"),
                        height: 70,
                        //width: 10,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(30.0, 40.0, 0.0, 30.0),
                      child: Text(
                        "Login If you have an account",
                        style: subTitleWhite2SansRegular(),
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
                              padding:
                                  EdgeInsets.fromLTRB(30.0, 0.0, 30.0, 15.0),
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
                                      //initialValue: 'example@email.com',
                                      style: hintStyleDark(),
                                      keyboardType: TextInputType.emailAddress,
                                      validator: (value) => value.isEmpty
                                          ? 'Email cannot be empty'
                                          : !value.contains('@')
                                              ? 'Incorrect Email'
                                              : null,
                                      onSaved: (String value) {
                                        _emailController.text = value;
                                      },
                                      controller: _emailController,
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
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding:
                                  EdgeInsets.fromLTRB(30.0, 0.0, 30.0, 0.0),
                              child: Stack(
                                children: <Widget>[
                                  Container(
                                    width: screenWidth(context) * 0.83,
                                    color: Colors.white,
                                    padding: EdgeInsets.only(left: 65.0),
                                    child: TextFormField(
                                      cursorColor: border,
                                      textAlign: TextAlign.left,
                                      decoration: new InputDecoration(
                                        border: InputBorder.none,
                                        hintText: 'Password',
                                        hintStyle: hintStyleDark(),
                                      ),
                                      //initialValue: 'Abc@12.34',
                                      keyboardType: TextInputType.text,
                                      obscureText: true,
                                      style: hintStyleDark(),
                                      validator: (value) => value.isEmpty
                                          ? 'Password cannot be empty'
                                          : value.length < 6
                                              ? 'Password must contain at least 6 Characters'
                                              : null,
                                      controller: _passwordController,
                                      onSaved: (String value) {
                                        _passwordController.text = value;
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
                                            Icons.lock_outline,
                                            color: Colors.white,
                                            size: 20.0,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: screenWidth(context),
                              padding: const EdgeInsets.only(
                                  left: 16.0, right: 30.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Checkbox(
                                        value: checkboxValue,
                                        onChanged: onChangedCheckBoxValue,
                                        activeColor: secondary,
                                      ),
                                      Text(
                                        "Remember me",
                                        style: smallAddressWhiteSansRegular(),
                                      ),
                                    ],
                                  ),
                                  InkWell(
                                    onTap: () {
                                      // Navigator.of(context).pushNamed(ResetPassword.tag);--------- navigate reset password window
                                    },
                                    child: Text(
                                      "Forgot Password",
                                      style: smallAddressWhiteSansRegular(),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsetsDirectional.only(
                                top: 15.0,
                                start: 45.0,
                                end: 45.0,
                                bottom: 10.0,
                              ),
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
                                        "LOGIN",
                                        style: subTitleWhiteSansRegular(),
                                      ),
                                      new Padding(
                                        padding: new EdgeInsets.only(
                                            left: 5.0, right: 5.0),
                                      ),
                                      loading
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
                                    _login();
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
            ),
            Align(
              alignment: AlignmentDirectional.bottomCenter,
              child: ListView(
                padding: EdgeInsets.only(
                  left: 30.0,
                  right: 30.0,
                  bottom: 40.0,
                ),
                shrinkWrap: true,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Or Sing In using",
                        style: subTitleWhite2SansRegular(),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 30.0, bottom: 30.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Flexible(
                          flex: 6,
                          child: InkWell(
                            onTap: () {},
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  height: 50.0,
                                  width: 50.0,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8.0),
                                    color: Colors.white,
                                  ),
                                  child: new Icon(
                                    FontAwesomeIcons.google,
                                    color: Colors.grey.shade700,
                                    size: 20.0,
                                  ),
                                ),
                                Text(
                                  "Google",
                                  style: categoryWhiteSansRegular(),
                                )
                              ],
                            ),
                          ),
                        ),
                        Flexible(
                          flex: 6,
                          child: InkWell(
                            onTap: () {
                              //_facebookLogin,----------------------------------------- facebook login function ----------------------------
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8.0),
                                    color: Colors.white,
                                  ),
                                  height: 50.0,
                                  width: 50.0,
                                  child: new Icon(
                                    FontAwesomeIcons.facebookF,
                                    color: Colors.grey.shade700,
                                    size: 20.0,
                                  ),
                                ),
                                Text(
                                  "Facebook",
                                  style: categoryWhiteSansRegular(),
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
                      // Navigator.of(context).pushNamed(Register.tag);// -------------------------- navigate to register  -------------------
                    },
                    child: Container(
                      alignment: AlignmentDirectional.center,
                      child: Text(
                        "Don't Have an Account? Register",
                        style: subTitleWhiteUnderline2SansRegular(),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
