import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

const keyIsLogin = "isLogin";
const keyEmail = "email";

const navigatorLogin = "/login";
const navigatorDashboard = "/dashboard";
const navigatorAboutApp = "/about_app";
const navigatorCheckInOut = "/check_in_out";

Widget buildCircularProgressIndicator() {
  if (Platform.isIOS) {
    return CupertinoActivityIndicator();
  } else {
    return CircularProgressIndicator();
  }
}