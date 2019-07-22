import 'package:json_annotation/json_annotation.dart';

part 'login_body.g.dart';

@JsonSerializable()
class LoginBody {
  @JsonKey(name: 'email')
  String email;
  @JsonKey(name: 'password')
  String password;

  LoginBody({this.email, this.password});

  factory LoginBody.fromJson(Map<String, dynamic> json) => _$LoginBodyFromJson(json);

  Map<String, dynamic> toJson() => _$LoginBodyToJson(this);

  @override
  String toString() {
    return 'LoginBody{email: $email, password: $password}';
  }

}