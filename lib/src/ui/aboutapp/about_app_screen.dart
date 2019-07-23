import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_version/get_version.dart';

class AboutAppScreen extends StatefulWidget {
  @override
  _AboutAppScreenState createState() => _AboutAppScreenState();
}

class _AboutAppScreenState extends State<AboutAppScreen> {
  String _versionName = "1.0.0";

  @override
  void initState() {
    _getVersionApp();
    super.initState();
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
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Stack(
          children: <Widget>[
            Center(
              child: Wrap(
                direction: Axis.vertical,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: <Widget>[
                  Container(
                    width: mediaQuery.size.width / 3,
                    height: mediaQuery.size.width / 3,
                    child: FlareActor(
                      'assets/images/material_fingerprint.flr',
                      animation: 'default',
                    ),
                  ),
                  Text(
                    'Rapatory Fingerprint',
                    style: Theme.of(context).textTheme.display1.merge(
                          TextStyle(color: Colors.grey[800], fontSize: 24.0),
                        ),
                  ),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'by',
                          style: TextStyle(
                            color: Colors.grey[500],
                          ),
                        ),
                        TextSpan(
                          text: ' Nusa',
                          style: TextStyle(
                            color: Color(0xFF3E9EB2),
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0,
                          ),
                        ),
                        TextSpan(
                          text: 'net',
                          style: TextStyle(
                            color: Color(0xFF3E9EB2),
                            fontSize: 18.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(mediaQuery.padding.bottom +
                  ((mediaQuery.padding.bottom == 0.0) ? 16.0 : 0.0)),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Text('v$_versionName'),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                left: 16.0,
                top: mediaQuery.padding.top + 16,
              ),
              child: Align(
                alignment: Alignment.topLeft,
                child: Container(
                  width: 48.0,
                  height: 48.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  child: IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  _getVersionApp() async {
    try {
      _versionName = await GetVersion.projectVersion;
      setState(() {});
    } on PlatformException {
      _versionName = "1.0.0";
    }
  }
}
