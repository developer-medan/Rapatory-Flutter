// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attendance_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AttendanceResponse _$AttendanceResponseFromJson(Map<String, dynamic> json) {
  return AttendanceResponse(
    data: (json['data'] as List)
        ?.map((e) => e == null
            ? null
            : AttendanceItemResponse.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$AttendanceResponseToJson(AttendanceResponse instance) =>
    <String, dynamic>{
      'data': instance.data,
    };

AttendanceItemResponse _$AttendanceItemResponseFromJson(
    Map<String, dynamic> json) {
  return AttendanceItemResponse(
    email: json['email'] as String,
    time: json['time'] as int,
    latitude: (json['latitude'] as num)?.toDouble(),
    longitude: (json['longitude'] as num)?.toDouble(),
    type: json['type'] as int,
  );
}

Map<String, dynamic> _$AttendanceItemResponseToJson(
        AttendanceItemResponse instance) =>
    <String, dynamic>{
      'email': instance.email,
      'time': instance.time,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'type': instance.type,
    };
