import 'package:json_annotation/json_annotation.dart';

part 'profile_response.g.dart';

@JsonSerializable()
class ProfileResponse {
  @JsonKey(name: 'employee_id')
  String employeeId;
  @JsonKey(name: 'name')
  String name;
  @JsonKey(name: 'position')
  String position;
  @JsonKey(name: 'manager')
  String manager;
  @JsonKey(name: 'photo_profile')
  String photoProfile;

  ProfileResponse(
      {this.employeeId,
      this.name,
      this.position,
      this.manager,
      this.photoProfile});

  factory ProfileResponse.fromJson(Map<String, dynamic> json) =>
      _$ProfileResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ProfileResponseToJson(this);

  @override
  String toString() {
    return 'ProfileResponse{employeeId: $employeeId, name: $name, position: $position, manager: $manager, photoProfile: $photoProfile}';
  }
}
