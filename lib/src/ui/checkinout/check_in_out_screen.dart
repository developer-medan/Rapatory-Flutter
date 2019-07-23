import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:rapatory_flutter/values/color_assets.dart';

class CheckInOutScreen extends StatefulWidget {
  @override
  _CheckInOutScreenState createState() => _CheckInOutScreenState();
}

class _CheckInOutScreenState extends State<CheckInOutScreen> {
  LocationData _currentLocation;
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
            _buildWidgetPanelBottom(mediaQuery, context),
            Align(
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
            )
          ],
        ),
      ),
    );
  }

  Widget _buildWidgetPanelBottom(
      MediaQueryData mediaQuery, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Container(height: mediaQuery.size.height / 1.8),
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
                  Center(
                    child: Container(
                      width: mediaQuery.size.width / 6,
                      height: 4.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(72.0),
                        color: Colors.black12,
                      ),
                    ),
                  ),
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
                          onPressed: () {
                            // TODO: do something in here
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
                          onPressed: () {
                            // TODO: do something in here
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
