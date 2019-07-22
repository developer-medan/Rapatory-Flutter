import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:rapatory_flutter/values/color_assets.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: <Widget>[
            HeaderImage(),
            FormLogin(),
          ],
        ),
      ),
    );
  }
}

class HeaderImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    return ClipPath(
      child: Container(
        height: mediaQuery.size.height / 1.6,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF6F5F8), Color(0xFFE2E2E4)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              width: mediaQuery.size.width / 3,
              height: mediaQuery.size.width / 3,
              child: FlareActor(
                "assets/images/material_fingerprint.flr",
                animation: "default",
              ),
            ),
            Text(
              'Rapatory Fingerprint',
              style: Theme.of(context).textTheme.display1.merge(
                    TextStyle(
                      color: Colors.grey[800],
                      fontSize: 24.0,
                    ),
                  ),
              maxLines: 2,
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
                  ),
                ],
              ),
            )
          ],
        ),
      ),
      clipper: BottomWaveClipper(),
    );
  }
}

class BottomWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();

    // Since the wave goes vertically lower than bottom left starting point,
    // we'll have to make this point a little higher.
    path.lineTo(0.0, size.height - 20);

    var firstControlPoint = Offset(size.width / 4, size.height);
    var firstEndPoint = Offset(size.width / 2.25, size.height - 30.0);
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);

    var secondControlPoint =
        Offset(size.width - (size.width / 3.25), size.height - 65);
    var secondEndPoint = Offset(size.width, size.height - 40);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);

    // The bottom right point also isn't at the same level as its left counterpart,
    // so we'll adjust that one too.
    path.lineTo(size.width, size.height - 40);
    path.lineTo(size.width, 0.0);

    // Draws a straight line from current point to the first point of the path.
    // In this case (0, 0), since that's where the paths start by default.
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}

class FormLogin extends StatefulWidget {
  @override
  _FormLoginState createState() => _FormLoginState();
}

class _FormLoginState extends State<FormLogin> {
  TextEditingController _controllerEmail;
  TextEditingController _controllerPassword;

  @override
  void initState() {
    super.initState();
    _controllerEmail = TextEditingController();
    _controllerPassword = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
      child: Column(
        children: <Widget>[
          TextField(
            controller: _controllerEmail,
            decoration: InputDecoration(
              labelText: "Email",
            ),
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
          ),
          SizedBox(height: 12.0),
          TextField(
            controller: _controllerPassword,
            decoration: InputDecoration(
              labelText: "Password",
            ),
            keyboardType: TextInputType.text,
            obscureText: true,
            textInputAction: TextInputAction.done,
          ),
          SizedBox(height: 12.0),
          Container(
            width: double.infinity,
            child: RaisedButton(
              child: Text(
                'LOG IN',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(72.0),
              ),
              padding: EdgeInsets.symmetric(vertical: 12.0),
              color: ColorAssets.primarySwatchColor,
              onPressed: () {
                print('login');
                // TODO: do something in here
              },
            ),
          ),
          SizedBox(height: 12.0),
          GestureDetector(
            onTap: () {
              print('tap sign up now');
              // TODO: do something in here
            },
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "Don't have an account? ",
                    style: TextStyle(
                      color: ColorAssets.primaryTextColor,
                    ),
                  ),
                  TextSpan(
                    text: "Sign up now",
                    style: TextStyle(
                      color: ColorAssets.primarySwatchColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
