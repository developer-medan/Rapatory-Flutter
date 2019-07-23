import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rapatory_flutter/src/models/profile/profile_response.dart';
import 'package:rapatory_flutter/src/utils/utils.dart';
import 'package:rapatory_flutter/values/color_assets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DashboardScreen extends StatelessWidget {
  var _paddingTopScreen = 0.0;
  String _name = '';
  String _position = '';
  String _photoProfile = '';
  String _employeeId = '';
  String _manager = '';
  var _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    _paddingTopScreen = mediaQuery.padding.top;

    return Scaffold(
      key: _scaffoldKey,
      body: SafeArea(
        top: false,
        child: Stack(
          children: <Widget>[
            Container(
              color: Color(0xFFF5F5F5),
            ),
            WaveHeader(),
            _buildWidgetLoadData(),
            /*_buildWidgetPhotoProfile(paddingTopScreen),
            _buildWidgetPersonalData(paddingTopScreen, context),*/
          ],
        ),
      ),
    );
  }

  Widget _buildWidgetLoadData() {
    return FutureBuilder(
      future: _doLoadPersonalData(),
      builder: (BuildContext context, AsyncSnapshot<ProfileResponse> snapshot) {
        if (snapshot.hasData) {
          var profileResponse = snapshot.data;
          _name = profileResponse.name;
          _position = profileResponse.position;
          _photoProfile = profileResponse.photoProfile;
          _employeeId = profileResponse.employeeId;
          _manager = profileResponse.manager;
          return Stack(
            children: <Widget>[
              _buildWidgetPhotoProfile(),
              _buildWidgetPersonalData(context)
            ],
          );
        } else if (snapshot.hasError) {
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Error'),
                  content: Text('Error occured.'),
                  actions: <Widget>[
                    FlatButton(
                      child: Text('Exit'),
                      onPressed: () {
                        SystemChannels.platform
                            .invokeMethod('SystemNavigator.pop');
                      },
                    ),
                  ],
                );
              });
          return Container();
        }
        return _buildWidgetLoadingScreen();
      },
    );
  }

  Widget _buildWidgetLoadingScreen() {
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
  }

  Future<ProfileResponse> _doLoadPersonalData() async {
    var sharedPreferences = await SharedPreferences.getInstance();
    var email = sharedPreferences.getString(keyEmail) ?? '';
    var dio = Dio();
    var response = await dio.get(
      'http://lab.anc.nusa.net.id:8010/api/v1/rapatory/profile?email=$email',
      options: Options(headers: {
        'Accept': 'Application/json',
        'Content-Type': 'Application/json',
      }),
    );
    if (response.statusCode == 200) {
      var profileResponse = ProfileResponse.fromJson(response.data);
      return profileResponse;
    } else {
      return null;
    }
  }

  Widget _buildWidgetPersonalData(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          SizedBox(
            height: 170.0 + _paddingTopScreen + 35.0,
          ),
          Text(
            _name,
            style: Theme.of(context).textTheme.headline,
            textAlign: TextAlign.center,
          ),
          Text(
            _position,
            style: Theme.of(context).textTheme.subhead,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Wrap(
                direction: Axis.vertical,
                children: <Widget>[
                  Text(
                    'Employee ID',
                    style: TextStyle(
                      color: Colors.grey[500],
                    ),
                  ),
                  Text(_employeeId),
                ],
              ),
              Wrap(
                direction: Axis.vertical,
                children: <Widget>[
                  Text(
                    'Manager',
                    style: TextStyle(
                      color: Colors.grey[500],
                    ),
                  ),
                  Text(_manager),
                ],
              ),
            ],
          ),
          Expanded(
            child: _buildWidgetMenu(),
          ),
        ],
      ),
    );
  }

  Widget _buildWidgetMenu() {
    return ListView(
      shrinkWrap: true,
      children: <Widget>[
        Row(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Expanded(
              child: InkWell(
                onTap: () {
                  // TODO: do something in here
                  print('tap menu check in / out');
                },
                child: Container(
                  width: double.infinity,
                  height: 128.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(16.0),
                    color: Colors.white,
                  ),
                  child: Center(
                    child: Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      direction: Axis.vertical,
                      children: <Widget>[
                        Icon(
                          Icons.access_time,
                          color: ColorAssets.primarySwatchColor,
                          size: 32.0,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text('Check In / Out'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: 8.0),
            Expanded(
              child: InkWell(
                onTap: () {
                  // TODO: do something in here
                  print('tap menu attendance');
                },
                child: Container(
                  width: double.infinity,
                  height: 128.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(16.0),
                    color: Colors.white,
                  ),
                  child: Center(
                    child: Wrap(
                      direction: Axis.vertical,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.date_range,
                          color: ColorAssets.primarySwatchColor,
                          size: 32.0,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text('Attendance'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 8.0),
        Row(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Expanded(
              child: InkWell(
                onTap: () {
                  Navigator.of(_scaffoldKey.currentContext)
                      .pushNamed(navigatorAboutApp);
                },
                child: Container(
                  width: double.infinity,
                  height: 128.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(16.0),
                    color: Colors.white,
                  ),
                  child: Center(
                    child: Wrap(
                      direction: Axis.vertical,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.info_outline,
                          color: ColorAssets.primarySwatchColor,
                          size: 32.0,
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 8.0),
                          child: Text('About App'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: 8.0),
            Expanded(
              child: InkWell(
                onTap: () {
                  // TODO: do something in here
                  print('tap logout');
                },
                child: Container(
                  width: double.infinity,
                  height: 128.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(16.0),
                    color: Colors.white,
                  ),
                  child: Center(
                    child: Wrap(
                      direction: Axis.vertical,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.exit_to_app,
                          color: ColorAssets.primarySwatchColor,
                          size: 32.0,
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 8.0),
                          child: Text('Logout'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        )
      ],
    );
  }

  Widget _buildWidgetPhotoProfile() {
    return Container(
      width: double.infinity,
      child: Padding(
        padding: EdgeInsets.only(top: 70.0 + _paddingTopScreen),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 128.0,
              height: 128.0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(_photoProfile),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class WaveHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    var paddingTopScreen = mediaQuery.padding.top;
    return ClipPath(
      child: Container(
        height: 170.0 + paddingTopScreen,
        color: ColorAssets.primarySwatchColor,
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.only(top: paddingTopScreen + 16.0),
          child: Text(
            'Rapatory Fingerprint',
            style: Theme.of(context).textTheme.display1.merge(
                  TextStyle(
                    fontSize: 24.0,
                    color: Colors.white,
                  ),
                ),
            textAlign: TextAlign.center,
          ),
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

    path.lineTo(size.width, size.height - 40);
    path.lineTo(size.width, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
