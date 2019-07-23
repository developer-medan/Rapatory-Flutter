// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProfileResponse _$ProfileResponseFromJson(Map<String, dynamic> json) {
  return ProfileResponse(
    employeeId: json['employee_id'] as String,
    name: json['name'] as String,
    position: json['position'] as String,
    manager: json['manager'] as String,
    photoProfile: json['photo_profile'] as String,
  );
}

Map<String, dynamic> _$ProfileResponseToJson(ProfileResponse instance) =>
    <String, dynamic>{
      'employee_id': instance.employeeId,
      'name': instance.name,
      'position': instance.position,
      'manager': instance.manager,
      'photo_profile': instance.photoProfile,
    };
