import 'package:flutter/material.dart';

class MyUser {
  var _myUserId;
  var _myUserName;
  var _myUserEmail;
  var _myUserProfileUrl;

  MyUser();

  void setUserId(String id) {
    _myUserId = id;
  }

  void setUserName(String name) {
    _myUserName = name;
  }

  void setUserEmail(String email) {
    _myUserEmail = email;
  }

  void setUserProfileUrl(String url) {
    _myUserProfileUrl = url;
  }

  String getUserId() {
    return _myUserId;
  }

  String getUserName() {
    return _myUserName;
  }

  String getUserEmail() {
    return _myUserEmail;
  }

  String getUserProfileUrl() {
    return _myUserProfileUrl;
  }

  //------------- create profile pic using url globally ----------------------
  Widget createProfileImage() {
    return _myUserProfileUrl == ""
        ? ClipOval(
            child: Image.asset(
              "lib/assets/icon/user.png",
              width: 100,
              height: 100,
              color: Colors.white,
            ),
          )
        : _myUserProfileUrl != ""
            ? ClipOval(
                child: Image.network(
                  _myUserProfileUrl,
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ),
              )
            : ClipOval(
                child: Image.asset(
                  "lib/assets/icon/user.png",
                  width: 100,
                  height: 100,
                  color: Colors.white,
                ),
              );
  }
}
