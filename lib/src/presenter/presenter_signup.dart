import 'package:rapatory_flutter/src/model/view_model_signup.dart';
import 'package:rapatory_flutter/src/model/network.dart';
import 'package:rapatory_flutter/src/utils/utils.dart';
import 'package:rapatory_flutter/src/view/view_signup.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PresenterSignUp {

  set view(ViewSignUp viewSignUp) {}

  void doSignUp(ViewSignUp viewSignUp, ViewModelSignUp viewModelSignUp) {}

}

class BasicPresenterSignUp implements PresenterSignUp {
  ViewModelSignUp _viewModelSignUp;
  ViewSignUp _viewSignUp;
  NetworkProvider _networkProvider;

  final String TAG = "BasicPresenterSignUp";

  BasicPresenterSignUp() {
    this._viewModelSignUp = ViewModelSignUp();
    this._networkProvider = NetworkProvider();
  }

  @override
  set view(ViewSignUp viewSignUp) {
    this._viewSignUp = viewSignUp;
    this._viewSignUp.refreshData(this._viewModelSignUp);
  }

  @override
  void doSignUp(ViewSignUp viewSignUp, ViewModelSignUp viewModelSignUp) {
    this._viewSignUp = viewSignUp;
    this._viewModelSignUp = viewModelSignUp;

    Future<bool> future = this._networkProvider.postData(this._viewModelSignUp);
    future.then((bool isSuccessRegistered) async {
      if (isSuccessRegistered) {
        SharedPreferences sharedPreferences =
            await SharedPreferences.getInstance();
        await sharedPreferences.setBool(keyIsLogin, true);
        await sharedPreferences.setString(keyEmail, _viewModelSignUp.usernameTextEditor.text);
        _viewSignUp.signUpSuccess();
      } else {
        print("Register Failed");
      }
    }).catchError((var error) {
      print("error while register $error");
    });
  }
}
