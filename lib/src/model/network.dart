import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'view_model_signup.dart';

class NetworkProvider {

  Future<bool> postData(ViewModelSignUp _viewModelSignUp) async {
    var urlPost = "http://lab.anc.nusa.net.id:8010/api/v1/rapatory/register";
    var response = await http.post(urlPost, headers: {
      "accept": "application/json",
      "contentType": "application/json"
    }, body: {
      "employeeId": _viewModelSignUp.employeeIdTextEditor.text.toString(),
      "name": _viewModelSignUp.nameTextEditor.text.toString(),
      "position": _viewModelSignUp.positionTextEditor.text.toString(),
      "manager": _viewModelSignUp.managerTextEditor.text.toString(),
      "username": _viewModelSignUp.usernameTextEditor.text.toString(),
      "password": _viewModelSignUp.passwordTextEditor.text.toString()
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
