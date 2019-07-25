import 'package:built_value/json_object.dart';


class ResponseSignUp {

  final String employeeId;
  final String name;
  final String position;
  final String manager;
  final String username;
  final String password;

  ResponseSignUp({this.employeeId, this.name, this.position, this.manager, this.username, this.password});

  factory ResponseSignUp.fromJson(Map<String, dynamic> json) {
    return ResponseSignUp(
      employeeId: json['employeeId'],
      name: json['name'],
      position: json['position'],
      manager: json['manager'],
      username: json['username'],
      password: json['password']
    );
  }

}