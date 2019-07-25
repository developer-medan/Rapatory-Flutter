import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'model_signup_screen.dart';

class NetworkProvider {

  ModelSignUp _modelSignUp;

  NetworkProvider(this._modelSignUp);

  Future<bool> postData() async {
    var urlPost = "http://lab.anc.nusa.net.id:8010/api/v1/rapatory/register";
    var response = await http.post(urlPost, headers: {
      "accept": "application/json",
      "contentType": "application/json"
    }, body: {
      "employeeId": _modelSignUp.employeeIdTextEditor.text.toString(),
      "name": _modelSignUp.nameTextEditor.text.toString(),
      "position": _modelSignUp.positionTextEditor.text.toString(),
      "manager": _modelSignUp.managerTextEditor.text.toString(),
      "username": _modelSignUp.usernameTextEditor.text.toString(),
      "password": _modelSignUp.passwordTextEditor.text.toString()
    });
    if (response.statusCode == 201 || response.statusCode == 200) {
      var responseString = jsonDecode(response.body);
      if (responseString['message'] == "Register Success") {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }
}
