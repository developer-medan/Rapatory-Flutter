import 'package:json_annotation/json_annotation.dart';

part 'check_in_out_body.g.dart';

@JsonSerializable()
class CheckInOutBody {
  @JsonKey(name: 'email')
  String email;
  @JsonKey(name: 'time')
  int time;
  @JsonKey(name: 'latitude')
  double latitude;
  @JsonKey(name: "longitude")
  double longitude;
  @JsonKey(name: "typeCheck")
  int typeCheck;

  CheckInOutBody({
    this.email,
    this.time,
    this.latitude,
    this.longitude,
    this.typeCheck,
  });

  factory CheckInOutBody.fromJson(Map<String, dynamic> json) =>
      _$CheckInOutBodyFromJson(json);

  Map<String, dynamic> toJson() => _$CheckInOutBodyToJson(this);

  @override
  String toString() {
    return 'CheckInOutBody{email: $email, time: $time, latitude: $latitude, longitude: $longitude, typeCheck: $typeCheck}';
  }

}
