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
            WaveHeader(),
            _buildWidgetPhotoProfile(paddingTopScreen),
          ],
        ),
      ),
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
