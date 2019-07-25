import 'package:flutter/material.dart';
import 'package:rapatory_flutter/src/presenter/presenter_signup.dart';
import 'package:rapatory_flutter/src/ui/signup_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Rapatory',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SignUpScreen(new BasicPresenterSignUP(), title: 'Rapatory'),
    );
  }
}

