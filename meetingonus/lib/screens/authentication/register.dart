import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:meetingonus/style/style.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final FirebaseFirestore firestore = FirebaseFirestore.instance;

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  // Create a CollectionReference called users that references the firestore collection
  final CollectionReference users =
      FirebaseFirestore.instance.collection('users');

  String email, password, confirmPassword, name, phone;
  bool loading = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();


  bool _success; //to check user registration complete of not
  String _userEmail;

  @override
  void initState() {
    super.initState();
    Firebase.initializeApp();
  }

  //------------------------------- send data to firestore function ---------------------------------------
  Future<void> addUser(var id) {
    // Call the user's CollectionReference to add a new user
    return users.doc(id)
        .set({
          'user_name': _nameController.text,
          'email': _emailController.text,
          'password': _passwordController.text
        })
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  //-++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ User Registration Function +++++++++++++++++++++++++++++++++++++++++

  void _register() async {
    setState(() {
      loading = true;
    });
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    try {
      final User user = (await _auth.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      ))
          .user;

      if (user != null) {
        setState(() {
          _success = true;
          _userEmail = user.email;
        });
      } else {
        _success = false;
      }
      showInSnackBar('Successfully registered ' + _userEmail);
      addUser(user.uid);
      setState(() {
        loading = false;
      });
      Navigator.pop(context);
    } catch (e) {
      showInSnackBar('Registration Failed! Please Try Again');
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
                  mainAxisAlignment: MainAxisAlignment.center,
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
                      padding: EdgeInsets.fromLTRB(30.0, 40.0, 0.0, 30.0),
                      child: Text(
                        "Register If you don't have an account",
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
                          inputDecorationTheme: InputDecorationTheme(
                            labelStyle: TextStyle(
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
                                        _nameController.text = value;
                                      },
                                      controller: _nameController,
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
                              padding:
                                  EdgeInsets.fromLTRB(30.0, 0.0, 30.0, 15.0),
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
                                      cursorColor: border,
                                      decoration: new InputDecoration(
                                        border: InputBorder.none,
                                        hintText: 'Password',
                                        hintStyle: hintStyleDark(),
                                      ),
                                      keyboardType: TextInputType.text,
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
                                      obscureText: true,
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
                                  )
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
                                      decoration: new InputDecoration(
                                        border: InputBorder.none,
                                        hintText: 'Confirm Password',
                                        hintStyle: hintStyleDark(),
                                      ),
                                      keyboardType: TextInputType.text,
                                      style: hintStyleDark(),
                                      obscureText: true,
                                      validator: (value) => value.isEmpty
                                          ? 'Please confirm password'
                                          : _passwordController.text != value
                                              ? 'Passwords do not match'
                                              : null,
                                      onSaved: (String value) {
                                        confirmPassword = value;
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
                                        'REGISTER',
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
                                    _register();
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
              child: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  padding:
                      EdgeInsets.only(left: 30.0, right: 30.0, bottom: 60.0),
                  child: Text(
                    "Already have an Account ? Login",
                    style: subTitleWhiteUnderline2(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
