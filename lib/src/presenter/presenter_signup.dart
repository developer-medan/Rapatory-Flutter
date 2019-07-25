import 'dart:convert';
import 'dart:developer';

import 'package:rapatory_flutter/src/model/model_signup_screen.dart';
import 'package:rapatory_flutter/src/model/network.dart';
import 'package:http/http.dart' as http;
import 'package:rapatory_flutter/src/view/view_signup.dart';
import 'package:rxdart/rxdart.dart';

class PresenterSignUp {
  set view(ViewSignUp viewSignUp) {}

  void doSignUp() {}
}

class BasicPresenterSignUP implements PresenterSignUp {
  ModelSignUp _model;
  ViewSignUp _viewSignUp;
  NetworkProvider _networkProvider;
  PublishSubject<bool> _publishSubjectLoading;

  final String TAG = "BasicPresenterSignUp";

  BasicPresenterSignUP() {
    if (this._model == null && this._networkProvider == null) {
      this._model = ModelSignUp();
      _publishSubjectLoading = PublishSubject<bool>();
      _publishSubjectLoading.sink.add(false);
      this._networkProvider = NetworkProvider(this._model);
    }
  }

  @override
  set view(ViewSignUp viewSignUp) {
    this._viewSignUp = viewSignUp;
    this._viewSignUp.refreshData(this._model, this._publishSubjectLoading);
  }

  @override
  void doSignUp() {
    _publishSubjectLoading.sink.add(true);
    Future<bool> future = this._networkProvider.postData();
    future.then((bool isSuccessRegistered) {
      _publishSubjectLoading.add(false);
      if (isSuccessRegistered) {
        print("Register Success");
      } else {
        //showSnackbar
        print("Register Failed");
      }
    }).catchError((var error) {
      print("error while register $error");
    });
  }
}
