import 'dart:async';

import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:rapatory_flutter/src/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    startTime();
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF6F5F8), Color(0xFFE2E2E4)],
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(
              width: mediaQuery.size.width / 3,
              height: mediaQuery.size.width / 3,
              child: FlareActor(
                'assets/images/material_fingerprint.flr',
                animation: 'default',
              ),
            ),
            Text(
              'Rapatory Fingerprint',
              style: Theme.of(context).textTheme.display1,
              textAlign: TextAlign.center,
            ),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "by",
                    style: TextStyle(
                      color: Colors.grey[500],
                    ),
                  ),
                  TextSpan(
                    text: " Nusa",
                    style: TextStyle(
                      color: Color(0xFF3E9EB2),
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                    ),
                  ),
                  TextSpan(
                    text: "net",
                    style: TextStyle(
                      color: Color(0xFF3E9EB2),
                      fontSize: 18.0,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  startTime() async {
    return Timer(Duration(seconds: 2), () async {
      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      bool isLogin = sharedPreferences.getBool(keyIsLogin) ?? false;
      if (isLogin) {
        Navigator.of(context).pushReplacementNamed(navigatorDashboard);
      } else {
        Navigator.of(context).pushReplacementNamed(navigatorLogin);
      }
    });
  }
}
