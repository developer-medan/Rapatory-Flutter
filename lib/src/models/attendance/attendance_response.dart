import 'package:json_annotation/json_annotation.dart';

part 'attendance_response.g.dart';

@JsonSerializable()
class AttendanceResponse {
  @JsonKey(name: 'data')
  List<AttendanceItemResponse> data;
  @JsonKey(ignore: true)
  bool isError;

  AttendanceResponse({this.data, this.isError = false});

  factory AttendanceResponse.fromJson(Map<String, dynamic> json) =>
      _$AttendanceResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AttendanceResponseToJson(this);

  @override
  String toString() {
    return 'AttendanceResponse{data: $data}';
  }
}

@JsonSerializable()
class AttendanceItemResponse {
  @JsonKey(name: 'email')
  String email;
  @JsonKey(name: 'time')
  int time;
  @JsonKey(name: 'latitude')
  double latitude;
  @JsonKey(name: 'longitude')
  double longitude;
  @JsonKey(name: 'type')
  int type;

  AttendanceItemResponse({
    this.email,
    this.time,
    this.latitude,
    this.longitude,
    this.type,
  });

  factory AttendanceItemResponse.fromJson(Map<String, dynamic> json) =>
      _$AttendanceItemResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AttendanceItemResponseToJson(this);

  @override
  String toString() {
    return 'AttendanceItemResponse{email: $email, time: $time, latitude: $latitude, longitude: $longitude, type: $type}';
  }
}
