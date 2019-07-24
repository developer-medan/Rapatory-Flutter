import 'package:flutter/material.dart';
import 'package:rapatory_flutter/values/color_assets.dart';

import 'ui/aboutapp/about_app_screen.dart';
import 'ui/attendance/attendance_screen.dart';
import 'ui/checkinout/check_in_out_screen.dart';
import 'ui/dashboard/dashboard_screen.dart';
import 'ui/login/login_screen.dart';
import 'ui/splash/splash_screen.dart';
import 'utils/utils.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: true,
      theme: ThemeData(
        primaryColor: ColorAssets.primarySwatchColor,
        accentColor: ColorAssets.accentColor,
      ),
      home: SplashScreen(),
      routes: {
        navigatorLogin: (context) {
          return LoginScreen();
        },
        navigatorDashboard: (context) {
          return DashboardScreen();
        },
        navigatorAboutApp: (context) {
          return AboutAppScreen();
        },
        navigatorCheckInOut: (context) {
          return CheckInOutScreen();
        },
        navigatorAttendance: (context) {
          return AttendanceScreen();
        }
      },
    );
  }
}
