import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:rapatory_flutter/src/models/attendance/attendance_response.dart';
import 'package:rapatory_flutter/src/utils/utils.dart';
import 'package:rapatory_flutter/values/color_assets.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AttendanceScreen extends StatefulWidget {
  @override
  _AttendanceScreenState createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  final _publishSubject = PublishSubject<AttendanceResponse>();
  Completer<GoogleMapController> _controller = Completer();

  @override
  void initState() {
    doLoadData();
    super.initState();
  }

  @override
  void dispose() {
    _publishSubject.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Attendance'),
      ),
      body: SafeArea(
        child: StreamBuilder(
          stream: _publishSubject.stream,
          builder: (BuildContext context,
              AsyncSnapshot<AttendanceResponse> snapshot) {
            if (snapshot.hasData) {
              var attendanceResponse = snapshot.data;
              if (attendanceResponse.isError) {
                return Center(
                  child: Text('Error occured'),
                );
              } else {
                var listData = attendanceResponse.data;
                return Padding(
                  padding: const EdgeInsets.only(left: 16.0, top: 16.0, right: 16.0),
                  child: ListView.builder(
                    itemCount: listData.length,
                    itemBuilder: (context, index) {
                      var itemAttendanceResponse = listData[index];
                      var strTime = DateFormat("EEE, MMMM dd, yyyy HH:mm").format(
                        DateTime.fromMillisecondsSinceEpoch(
                                itemAttendanceResponse.time)
                            .toUtc(),
                      );

                      var markerCoordinate = Marker(
                        markerId: MarkerId(
                            '${itemAttendanceResponse.latitude},${itemAttendanceResponse.longitude}'),
                        position: LatLng(itemAttendanceResponse.latitude,
                            itemAttendanceResponse.longitude),
                        icon: BitmapDescriptor.defaultMarker,
                      );
                      final Set<Marker> listMarkers = {};
                      listMarkers.add(markerCoordinate);
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16.0)),
                          color: Colors.white,
                          child: Column(
                            children: <Widget>[
                              Container(
                                width: double.infinity,
                                height: 20.0,
                                decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(16.0),
                                    topRight: Radius.circular(16.0),
                                  ),
                                  color: ColorAssets.primarySwatchColor,
                                ),
                              ),
                              SizedBox(
                                width: double.infinity,
                                height: mediaQuery.size.width / 3,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: GoogleMap(
                                    mapType: MapType.normal,
                                    myLocationButtonEnabled: false,
                                    markers: listMarkers,
                                    initialCameraPosition: CameraPosition(
                                      target: LatLng(
                                          itemAttendanceResponse.latitude,
                                          itemAttendanceResponse.longitude),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16.0),
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                      flex: 1,
                                      child: Text(
                                        'Time',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Text(': $strTime'),
                                    )
                                  ],
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16.0),
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                      flex: 1,
                                      child: Text(
                                        'Coordinate',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                          ': ${itemAttendanceResponse.latitude}, ${itemAttendanceResponse.longitude}'),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16.0),
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                      flex: 1,
                                      child: Text(
                                        'Type',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        ': ' +
                                            (itemAttendanceResponse.type == 1
                                                ? 'Clock In'
                                                : 'Clock Out'),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(height: 16.0),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
              }
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error occured: ${snapshot.error.toString()}'),
              );
            }
            return _buildWidgetLoadingScreen();
          },
        ),
      ),
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
                shape: BoxShape.rectangle,
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

  void doLoadData() async {
    var sharedPreferences = await SharedPreferences.getInstance();
    var email = sharedPreferences.getString(keyEmail) ?? '';
    var dio = Dio();
    var response = await dio.get(
      'http://lab.anc.nusa.net.id:8010/api/v1/rapatory/attendance?email=$email',
      options: Options(
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json'
        },
      ),
    );
    if (response.statusCode == 200) {
      _publishSubject.sink.add(AttendanceResponse.fromJson(response.data));
    } else {
      _publishSubject.sink.add(AttendanceResponse(isError: true));
    }
  }
}
