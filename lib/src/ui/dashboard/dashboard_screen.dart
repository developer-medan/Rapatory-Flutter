import 'package:flutter/material.dart';
import 'package:rapatory_flutter/values/color_assets.dart';

class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    var paddingTopScreen = mediaQuery.padding.top;

    return Scaffold(
      body: SafeArea(
        top: false,
        child: Stack(
          children: <Widget>[
            Container(
              color: Color(0xFFF5F5F5),
            ),
            WaveHeader(),
            _buildWidgetPhotoProfile(paddingTopScreen),
            _buildWidgetPersonalData(paddingTopScreen, context),
          ],
        ),
      ),
    );
  }

  Widget _buildWidgetPersonalData(
      double paddingTopScreen, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          SizedBox(
            height: 170.0 + paddingTopScreen + 35.0,
          ),
          Text(
            'Angelica Agnesia',
            style: Theme.of(context).textTheme.headline,
            textAlign: TextAlign.center,
          ),
          Text(
            'Programmer',
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
                  Text('0201708'),
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
                  Text('David Lim'),
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
                  // TODO: do something in here
                  print('tap about app');
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

  Widget _buildWidgetPhotoProfile(double paddingTopScreen) {
    return Container(
      width: double.infinity,
      child: Padding(
        padding: EdgeInsets.only(top: 70.0 + paddingTopScreen),
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
                  image:
                      AssetImage("assets/images/img_sample_photo_profile.jpg"),
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
