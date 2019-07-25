// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'check_in_out_body.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CheckInOutBody _$CheckInOutBodyFromJson(Map<String, dynamic> json) {
  return CheckInOutBody(
    email: json['email'] as String,
    time: json['time'] as int,
    latitude: (json['latitude'] as num)?.toDouble(),
    longitude: (json['longitude'] as num)?.toDouble(),
    typeCheck: json['typeCheck'] as int,
  );
}

Map<String, dynamic> _$CheckInOutBodyToJson(CheckInOutBody instance) =>
    <String, dynamic>{
      'email': instance.email,
      'time': instance.time,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'typeCheck': instance.typeCheck,
    };
