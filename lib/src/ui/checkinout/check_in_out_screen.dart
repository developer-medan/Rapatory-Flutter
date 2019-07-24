import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:local_auth/local_auth.dart';
import 'package:location/location.dart';
import 'package:rapatory_flutter/src/models/checkinout/check_in_out_body.dart';
import 'package:rapatory_flutter/src/utils/utils.dart';
import 'package:rapatory_flutter/values/color_assets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CheckInOutScreen extends StatefulWidget {
  @override
  _CheckInOutScreenState createState() => _CheckInOutScreenState();
}

LocationData _currentLocation;

class _CheckInOutScreenState extends State<CheckInOutScreen> {
  StreamSubscription<LocationData> _locationSubscription;
  Location _locationService = Location();
  bool _permission = false;
  String error;
  bool currentWidget = true;

  Completer<GoogleMapController> _controller = Completer();
  static final CameraPosition _initialCamera = CameraPosition(
    target: LatLng(0, 0),
    zoom: 4,
  );
  final Set<Marker> _markers = {};

  CameraPosition _currentCameraPosition;
  GoogleMap googleMap;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  @override
  void dispose() {
    _locationSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            _buildWidgetGoogleMaps(mediaQuery),
            WidgetPanelBottomMenu(),
            _buildWidgetArrowBackToMainMenu(context),
          ],
        ),
      ),
    );
  }

  Widget _buildWidgetArrowBackToMainMenu(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 16.0, top: 16.0),
        child: Container(
          width: 42.0,
          height: 42.0,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            boxShadow: [
              BoxShadow(color: Colors.black, blurRadius: 5.0),
            ],
          ),
          child: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Color(0xFF757575),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildWidgetGoogleMaps(MediaQueryData mediaQuery) {
    return Container(
      width: double.infinity,
      height: mediaQuery.size.height / 1.5,
      child: GoogleMap(
        mapType: MapType.normal,
        myLocationButtonEnabled: true,
        initialCameraPosition: _initialCamera,
        markers: _markers,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
    );
  }

  initPlatformState() async {
    await _locationService.changeSettings(
        accuracy: LocationAccuracy.HIGH, interval: 1000);

    LocationData location;
    try {
      bool serviceStatus = await _locationService.serviceEnabled();
      print('Service status: $serviceStatus');
      if (serviceStatus) {
        _permission = await _locationService.requestPermission();
        print('Permission: $_permission');
        if (_permission) {
          location = await _locationService.getLocation();

          _locationSubscription = _locationService
              .onLocationChanged()
              .listen((LocationData result) async {
            _currentCameraPosition = CameraPosition(
              target: LatLng(result.latitude, result.longitude),
              zoom: 16.0,
            );

            final GoogleMapController controller = await _controller.future;
            controller.animateCamera(
                CameraUpdate.newCameraPosition(_currentCameraPosition));

            if (mounted) {
              setState(() {
                _currentLocation = result;
                _markers.clear();
                _markers.add(Marker(
                  markerId: MarkerId(_currentLocation.toString()),
                  position: LatLng(
                      _currentLocation.latitude, _currentLocation.longitude),
                  infoWindow: InfoWindow(
                    title: 'Your Location',
                  ),
                  icon: BitmapDescriptor.defaultMarker,
                ));
              });
            }
          });
        }
      } else {
        bool serviceStatusResult = await _locationService.requestService();
        print('Service status activated after request: $serviceStatusResult');
        if (serviceStatusResult) {
          initPlatformState();
        }
      }
    } on PlatformException catch (e) {
      print(e);
      if (e.code == 'PERMISSION_DENIED') {
        error = e.message;
      } else if (e.code == 'SERVICE_STATUS_ERROR  ') {
        error = e.message;
      }
      location = null;
    }
  }

  slowRefresh() async {
    _locationSubscription.cancel();
    await _locationService.changeSettings(
        accuracy: LocationAccuracy.BALANCED, interval: 10000);
    _locationSubscription =
        _locationService.onLocationChanged().listen((LocationData result) {
      if (mounted) {
        setState(() {
          _currentLocation = result;
        });
      }
    });
  }
}

class WidgetPanelBottomMenu extends StatefulWidget {
  @override
  _WidgetPanelBottomMenuState createState() => _WidgetPanelBottomMenuState();
}

class _WidgetPanelBottomMenuState extends State<WidgetPanelBottomMenu> {
  final LocalAuthentication auth = LocalAuthentication();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    return _buildWidgetContent(mediaQuery, context);
  }

  Future<bool> _checkBiometrics() async {
    bool canCheckBiometrics;
    try {
      canCheckBiometrics = await auth.canCheckBiometrics;
    } on PlatformException catch (e) {
      print(e);
    }
    if (!mounted) return false;
    return canCheckBiometrics;
  }

  Future<List<BiometricType>> _getAvailableBiometrics() async {
    List<BiometricType> availableBiometrics;
    try {
      availableBiometrics = await auth.getAvailableBiometrics();
    } on PlatformException catch (e) {
      print(e);
    }
    if (!mounted) return null;
    return availableBiometrics;
  }

  Future<void> authenticateFingerprint(int type) async {
    bool authenticated = false;
    try {
      authenticated = await auth.authenticateWithBiometrics(
          localizedReason: 'Scan your fingerprint to authenticate',
          useErrorDialogs: false,
          stickyAuth: false);
    } on PlatformException catch (e) {
      print('authenticated error: ' + e.message);
    }
    if (!mounted) return;
    if (authenticated) {
      var sharedPreferences = await SharedPreferences.getInstance();
      var email = sharedPreferences.getString(keyEmail) ?? '';
      var dio = Dio();
      var checkInOutBody = CheckInOutBody(
        email: email,
        time: DateTime.now().millisecondsSinceEpoch,
        latitude: _currentLocation.latitude,
        longitude: _currentLocation.longitude,
        typeCheck: type,
      );
      var bodyRequest = checkInOutBody.toJson();
      var response = await dio.post(
        'http://lab.anc.nusa.net.id:8010/api/v1/rapatory/check',
        data: bodyRequest,
        options: Options(
          headers: {
            'Accept': 'Application/json',
            'Content-Type': 'Application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            var strTime = DateFormat('HH:mm').format(DateTime.now());
            var strLatitude = _currentLocation.latitude.toStringAsFixed(7);
            var strLongitude = _currentLocation.longitude.toStringAsFixed(7);
            return DialogFingerprintSuccess(
              title: type == 1 ? 'Clock In Success' : 'Clock Out Success',
              time: strTime,
              latitude: strLatitude,
              longitude: strLongitude,
            );
          },
        );
      } else {
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text(type == 1 ? 'Clock In Failed' : 'Clock Out Failed'),
        ));
      }
    }
  }

  Widget _buildWidgetContent(MediaQueryData mediaQuery, BuildContext context) {
    return _buildWidgetMainMenu(mediaQuery, context);
  }

  Widget _buildWidgetMainMenu(MediaQueryData mediaQuery, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        _buildWidgetContainerPanelBottom(mediaQuery),
        Expanded(
          child: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(32.0),
                topRight: Radius.circular(32.0),
              ),
              color: Colors.white,
            ),
            child: Padding(
              padding: EdgeInsets.only(left: 16.0, top: 8.0, right: 16.0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  _buildWidgetPin(mediaQuery),
                  SizedBox(height: 16.0),
                  Text(
                    'Would you like to Clock In or Out?',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.title.merge(
                          TextStyle(
                            color: ColorAssets.primarySwatchColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                  ),
                  SizedBox(height: 16.0),
                  Image.asset(
                    'assets/images/img_illustration_clock_in_out.png',
                    width: mediaQuery.size.width / 1.5,
                    height: mediaQuery.size.height / 5.8,
                    fit: BoxFit.fill,
                  ),
                  SizedBox(height: 16.0),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: RaisedButton(
                          child: Text(
                            'Clock In',
                            style: TextStyle(
                                color: ColorAssets.primarySwatchColor),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(72.0),
                            side: BorderSide(
                                color: ColorAssets.primarySwatchColor),
                          ),
                          color: Colors.white,
                          onPressed: () async {
                            var isSupportFingerprint = await _checkBiometrics();
                            var availableBiometrics =
                                await _getAvailableBiometrics();
                            if (Platform.isIOS) {
                              if (availableBiometrics
                                  .contains(BiometricType.fingerprint)) {
                                authenticateFingerprint(1);
                              } else {
                                // TODO: do something in here
                                Scaffold.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        'Your device not support fingerprint'),
                                  ),
                                );
                              }
                            } else {
                              if (isSupportFingerprint) {
                                authenticateFingerprint(1);
                              } else {
                                // TODO: do something in here
                                Scaffold.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        "Your device not support fingerprint"),
                                  ),
                                );
                              }
                            }
                          },
                        ),
                      ),
                      SizedBox(width: 16.0),
                      Expanded(
                        child: RaisedButton(
                          child: Text(
                            'Clock Out',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(72.0),
                          ),
                          color: ColorAssets.primarySwatchColor,
                          onPressed: () async {
                            var isSupportFingerprint = await _checkBiometrics();
                            var availableBiometrics =
                                await _getAvailableBiometrics();
                            if (Platform.isIOS) {
                              if (availableBiometrics
                                  .contains(BiometricType.fingerprint)) {
                                authenticateFingerprint(2);
                              } else {
                                // TODO: do something in here
                                Scaffold.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        'Your device not support fingerprint'),
                                  ),
                                );
                              }
                            } else {
                              if (isSupportFingerprint) {
                                authenticateFingerprint(2);
                              } else {
                                // TODO: do something in here
                                Scaffold.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        "Your device not support fingerprint"),
                                  ),
                                );
                              }
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildWidgetPin(MediaQueryData mediaQuery) {
    return Center(
      child: Container(
        width: mediaQuery.size.width / 6,
        height: 4.0,
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(72.0),
          color: Colors.black12,
        ),
      ),
    );
  }

  Widget _buildWidgetContainerPanelBottom(MediaQueryData mediaQuery) =>
      Container(height: mediaQuery.size.height / 1.8);
}

class DialogFingerprintSuccess extends StatelessWidget {
  final String title;
  final String time;
  final String latitude;
  final String longitude;

  DialogFingerprintSuccess({
    @required this.title,
    @required this.time,
    @required this.latitude,
    @required this.longitude,
  });

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      elevation: 0.0,
      backgroundColor: Colors.white,
      child: _buildWidgetDialogContent(mediaQuery, context),
    );
  }

  Widget _buildWidgetDialogContent(
      MediaQueryData mediaQuery, BuildContext context) {
    return Wrap(
      children: <Widget>[
        Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: const EdgeInsets.only(top: 8.0, right: 8.0),
            child: Icon(
              Icons.clear,
              size: 20.0,
              color: Colors.grey,
            ),
          ),
        ),
        Center(
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.title.merge(
                  TextStyle(
                    color: ColorAssets.primarySwatchColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
          ),
        ),
        SizedBox(height: 36.0),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: mediaQuery.size.width / 7),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  'Time',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  ': $time',
                  textAlign: TextAlign.start,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: mediaQuery.size.width / 7),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Text(
                  'Coordinate',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: Text(': $latitude\n  $longitude'),
              )
            ],
          ),
        ),
        SizedBox(height: 56.0),
        GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(16.0),
                bottomRight: Radius.circular(16.0),
              ),
              color: ColorAssets.primarySwatchColor,
            ),
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Center(
              child: Text(
                'Okay!',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
