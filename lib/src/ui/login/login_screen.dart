import 'package:dio/dio.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:rapatory_flutter/src/models/login/login_body.dart';
import 'package:rapatory_flutter/src/utils/utils.dart';
import 'package:rapatory_flutter/values/color_assets.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

PublishSubject<bool> _publishSubjectLoading;

class _LoginScreenState extends State<LoginScreen> {
  @override
  void initState() {
    _publishSubjectLoading = PublishSubject<bool>();
    _publishSubjectLoading.sink.add(false);
    super.initState();
  }

  @override
  void dispose() {
    _publishSubjectLoading.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            ListView(
              children: <Widget>[
                HeaderImage(),
                FormLogin(),
              ],
            ),
            _buildWidgetLoadingScreen(),
          ],
        ),
      ),
    );
  }

  Widget _buildWidgetLoadingScreen() {
    return StreamBuilder(
      stream: _publishSubjectLoading.stream,
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (snapshot.hasData) {
          bool isLoading = snapshot.data;
          if (isLoading) {
            return Container(
              width: double.infinity,
              height: double.infinity,
              child: Stack(
                children: <Widget>[
                  Container(
                    width: double.infinity,
                    height: double.infinity,
                    color: Color(0x90212121),
                  ),
                  Center(
                    child: Container(
                      width: 100.0,
                      height: 100.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24.0),
                        color: Colors.white,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(36.0),
                        child: buildCircularProgressIndicator(),
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else {
            return Container();
          }
        } else {
          return Container();
        }
      },
    );
  }
}

class HeaderImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    return ClipPath(
      child: Container(
        height: mediaQuery.size.height / 1.7,
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
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class FormLogin extends StatefulWidget {
  @override
  _FormLoginState createState() => _FormLoginState();
}

class _FormLoginState extends State<FormLogin> {
  Dio _dio = Dio();
  TextEditingController _controllerEmail = TextEditingController();
  TextEditingController _controllerPassword = TextEditingController();
  final _focusPassword = FocusNode();
  bool _isEmailValid = true;
  bool _isPasswordValid = true;

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
              errorText: _isEmailValid ? null : "Email can't be empty",
            ),
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            onSubmitted: (email) {
              setState(() => _isEmailValid = email.isNotEmpty);
              if (_isEmailValid) {
                FocusScope.of(context).requestFocus(_focusPassword);
              }
            },
          ),
          SizedBox(height: 12.0),
          TextField(
            controller: _controllerPassword,
            focusNode: _focusPassword,
            decoration: InputDecoration(
              labelText: "Password",
              errorText: _isPasswordValid ? null : "Password can't be empty",
            ),
            keyboardType: TextInputType.text,
            obscureText: true,
            textInputAction: TextInputAction.done,
            onSubmitted: (password) {
              String email = _controllerEmail.text;
              setState(() {
                _isEmailValid = email.isNotEmpty;
                _isPasswordValid = password.isNotEmpty;
              });
              if (_isEmailValid && _isPasswordValid) {
                _doLogin(email, password);
              }
            },
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
                String email = _controllerEmail.text;
                String password = _controllerPassword.text;
                setState(() {
                  _isEmailValid = email.isNotEmpty;
                  _isPasswordValid = password.isNotEmpty;
                });
                if (_isEmailValid && _isPasswordValid) {
                  _doLogin(email, password);
                }
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

  void _doLogin(String email, String password) async {
    try {
      _publishSubjectLoading.sink.add(true);
      var loginBody = LoginBody(email: email, password: password);
      var response = await _dio.post(
        "http://lab.anc.nusa.net.id:8010/api/v1/rapatory",
        data: loginBody.toJson(),
        options: Options(
          headers: {
            "Accept": "application/json",
            "Content-Type": "application/json",
          },
        ),
      );
      if (response.statusCode == 200) {
        SharedPreferences sharedPreferences =
            await SharedPreferences.getInstance();
        await sharedPreferences.setBool(keyIsLogin, true);
        await sharedPreferences.setString(keyEmail, email);
        _controllerEmail.clear();
        _controllerPassword.clear();
        _publishSubjectLoading.sink.add(false);
        Navigator.of(context).pushReplacementNamed(navigatorDashboard);
      } else {
        _showErrorSnackBar();
      }
    } on DioError catch (e) {
      _showErrorSnackBar();
    }
  }

  void _showErrorSnackBar() {
    _controllerPassword.clear();
    _publishSubjectLoading.sink.add(false);
    Scaffold.of(context).showSnackBar(
      SnackBar(
        content: Text("Login failed"),
      ),
    );
  }
}
