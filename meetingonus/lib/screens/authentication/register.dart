import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;


class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _success; //to check user registration complete of not
  String _userEmail;

  //-++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ User Registration Function +++++++++++++++++++++++++++++++++++++++++

  void _register() async {
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
      //_alertMoveToLogin('Successfully registered ' + _userEmail);
    } catch (e) {
      //_alertCommon('Registration Failed! Please Try Again');
    }
  }
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}


