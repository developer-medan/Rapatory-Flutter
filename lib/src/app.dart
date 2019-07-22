import 'package:flutter/material.dart';
import 'package:rapatory_flutter/values/color_assets.dart';

import 'ui/login/login_screen.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: true,
      theme: ThemeData(
        primaryColor: ColorAssets.primarySwatchColor,
        accentColor: ColorAssets.accentColor,
      ),
      home: LoginScreen(),
    );
  }
}
