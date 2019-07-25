import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rapatory_flutter/src/model/view_model_signup.dart';
import 'package:rapatory_flutter/src/presenter/presenter_signup.dart';
import 'package:rapatory_flutter/src/utils/utils.dart';
import 'package:rapatory_flutter/src/view/view_signup.dart';
import 'package:rxdart/rxdart.dart';

class SignUpScreen extends StatefulWidget {
  final String title;
  final PresenterSignUp _presenterSignUp;

  SignUpScreen(this._presenterSignUp, {this.title, Key key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> implements ViewSignUp{

  ViewModelSignUp _viewModelSignUp;

  @override
  void initState() {
    super.initState();
    this.widget._presenterSignUp.view = this;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            HeaderTitle(widget.title),
            FormSignUp(this.widget._presenterSignUp, this._viewModelSignUp, this),
            //_buildWidgetLoadingScreen(),
          ],
        ),
      ),
    );
  }

  @override
  void refreshData(ViewModelSignUp viewModelSignUp) {
    setState(() {
      this._viewModelSignUp = viewModelSignUp;
    });
  }

  @override
  void signUpSuccess() {
    Navigator.pushNamed(context, navigatorDashboard);
  }

//  Widget _buildWidgetLoadingScreen() {
//    return StreamBuilder(
//      stream: _publishSubjectLoading.stream,
//      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
//        if (snapshot.hasData) {
//          bool isLoading = snapshot.data;
//          if (isLoading) {
//            return Container(
//              width: double.infinity,
//              height: double.infinity,
//              child: Stack(
//                children: <Widget>[
//                  Container(
//                    width: double.infinity,
//                    height: double.infinity,
//                    color: Color(0x90212121),
//                  ),
//                  Center(
//                    child: Container(
//                      width: 100.0,
//                      height: 100.0,
//                      decoration: BoxDecoration(
//                          borderRadius: BorderRadius.circular(20.0),
//                          color: Colors.white),
//                      child: Padding(
//                        padding: const EdgeInsets.all(24.0),
//                        child: Platform.isIOS
//                            ? CupertinoActivityIndicator()
//                            : CircularProgressIndicator,
//                      ),
//                    ),
//                  )
//                ],
//              ),
//            );
//          } else {
//            return Container();
//          }
//        } else {
//          return Container();
//        }
//      },
//    );
//  }

}

class HeaderTitle extends StatelessWidget {
  final String title;

  HeaderTitle(this.title);

  @override
  Widget build(BuildContext context) {
    var widgetTextByNusanet = new WidgetTextByNusanet();
    var widgetTextTitle = new WidgetTextTitle(title: title);
    return Container(
      child: Column(
        children: <Widget>[
          widgetTextTitle,
          widgetTextByNusanet,
        ],
      ),
    );
  }
}

class WidgetTextByNusanet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);

    return Container(
        padding: EdgeInsets.only(left: mediaQuery.size.width / 2.5),
        width: mediaQuery.size.width,
        height: 50,
        child: Row(
          children: <Widget>[
            Text('by',
                style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.normal,
                    color: Colors.grey)),
            Text(' Nusa',
                style: TextStyle(
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue)),
            Text(
              'net',
              style: TextStyle(
                  fontSize: 30.0,
                  fontStyle: FontStyle.normal,
                  color: Colors.green),
            ),
          ],
        ));
  }
}

class WidgetTextTitle extends StatelessWidget {
  const WidgetTextTitle({
    Key key,
    @required this.title,
  }) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    return Container(
      width: mediaQuery.size.width,
      padding: EdgeInsets.fromLTRB(20.0, 110.0, 0.0, 0.0),
      child: Text(
        this.title,
        style: TextStyle(
            fontSize: 60.0,
            fontWeight: FontWeight.bold,
            color: Colors.deepPurple),
        textAlign: TextAlign.left,
      ),
    );
  }
}

class FormSignUp extends StatefulWidget {
  final PresenterSignUp _presenterSignUp;
  final ViewModelSignUp _viewModelSignUp;
  final ViewSignUp _viewSignUp;

  FormSignUp(this._presenterSignUp, this._viewModelSignUp, this._viewSignUp);

  @override
  _FormSignUpState createState() => _FormSignUpState();
}

class _FormSignUpState extends State<FormSignUp> {
  bool _isEmployeeIdValid = true;
  bool _isNameValid = true;
  bool _isPositionValid = true;
  bool _isManagerValid = true;
  bool _isUsernameValid = true;
  bool _isPasswordValid = true;


  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    return Container(
      padding: EdgeInsets.only(top: 50.0),
      margin: EdgeInsets.all(20.0),
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 10,
          ),
          Container(
            height: 50.0,
            child: Material(
              borderRadius: BorderRadius.circular(10.0),
              shadowColor: Colors.grey,
              color: Colors.white,
              elevation: 7,
              child: Center(
                child: TextField(
                  maxLines: 1,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                      errorText: _isEmployeeIdValid
                          ? null
                          : "EmployeeId can't be empty",
                      contentPadding: EdgeInsets.fromLTRB(10, 15.0, 10, 15.0),
                      border: InputBorder.none,
                      hintText: 'EmployeeId',
                      labelStyle: TextStyle(
                        fontSize: 25,
                      )),
                  onSubmitted: (employeeId) {
                    _isEmployeeIdValid = employeeId.isNotEmpty;
                    if (_isEmployeeIdValid) {
                      FocusScope.of(context).requestFocus(FocusNode());
                    }
                  },
                  controller: this.widget._viewModelSignUp.employeeIdTextEditor,
                ),
              ),
            ),
          ),
          SizedBox(height: 15),
          Container(
            height: 50.0,
            child: Material(
              borderRadius: BorderRadius.circular(10.0),
              shadowColor: Colors.grey,
              color: Colors.white,
              elevation: 7,
              child: Center(
                child: TextField(
                  maxLines: 1,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(10, 15.0, 10, 15.0),
                      border: InputBorder.none,
                      errorText: _isNameValid ? null : "Name can't be Empty",
                      hintText: 'Name',
                      labelStyle: TextStyle(
                        fontSize: 25,
                      )),
                  onSubmitted: (name) {
                    _isNameValid = name.isNotEmpty;
                    if (_isEmployeeIdValid && _isNameValid) {
                      FocusScope.of(context).requestFocus(FocusNode());
                    }
                  },
                  controller: this.widget._viewModelSignUp.nameTextEditor,
                ),
              ),
            ),
          ),
          SizedBox(height: 15),
          Container(
            height: 50.0,
            child: Material(
              borderRadius: BorderRadius.circular(10.0),
              shadowColor: Colors.grey,
              color: Colors.white,
              elevation: 7,
              child: Center(
                child: TextField(
                  maxLines: 1,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(10, 15.0, 10, 15.0),
                      border: InputBorder.none,
                      errorText:
                          _isPositionValid ? null : "Position can't be Empty",
                      hintText: 'Position',
                      labelStyle: TextStyle(
                        fontSize: 25,
                      )),
                  onSubmitted: (position) {
                    _isEmployeeIdValid =
                        this.widget._viewModelSignUp.employeeIdTextEditor.text.isNotEmpty;
                    _isNameValid = this.widget._viewModelSignUp.nameTextEditor.text.isNotEmpty;
                    _isPositionValid = position.isNotEmpty;
                    if (_isEmployeeIdValid &&
                        _isNameValid &&
                        _isPositionValid) {
                      FocusScope.of(context).requestFocus(FocusNode());
                    }
                  },
                  controller: this.widget._viewModelSignUp.positionTextEditor,
                ),
              ),
            ),
          ),
          SizedBox(height: 15),
          Container(
            height: 50.0,
            child: Material(
              borderRadius: BorderRadius.circular(10.0),
              shadowColor: Colors.grey,
              color: Colors.white,
              elevation: 7,
              child: Center(
                child: TextField(
                  maxLines: 1,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(10, 15.0, 10, 15.0),
                      border: InputBorder.none,
                      errorText:
                          _isManagerValid ? null : "Manager can't be Empty",
                      hintText: 'Manager',
                      labelStyle: TextStyle(
                        fontSize: 25,
                      )),
                  onSubmitted: (manager) {
                    _isEmployeeIdValid =
                        this.widget._viewModelSignUp.employeeIdTextEditor.text.isNotEmpty;
                    _isNameValid = this.widget._viewModelSignUp.nameTextEditor.text.isNotEmpty;
                    _isPositionValid =
                        this.widget._viewModelSignUp.positionTextEditor.text.isNotEmpty;
                    _isManagerValid = manager.isNotEmpty;
                    if (_isEmployeeIdValid &&
                        _isNameValid &&
                        _isPositionValid &&
                        _isManagerValid) {
                      FocusScope.of(context).requestFocus(FocusNode());
                    }
                  },
                  controller: this.widget._viewModelSignUp.managerTextEditor,
                ),
              ),
            ),
          ),
          SizedBox(height: 15),
          Container(
            height: 50.0,
            child: Material(
              borderRadius: BorderRadius.circular(10.0),
              shadowColor: Colors.grey,
              color: Colors.white,
              elevation: 7,
              child: Center(
                child: TextField(
                  keyboardType: TextInputType.emailAddress,
                  maxLines: 1,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(10, 15.0, 10, 15.0),
                      border: InputBorder.none,
                      errorText:
                          _isUsernameValid ? null : "Username can't be Empty",
                      hintText: 'Username',
                      labelStyle: TextStyle(
                        fontSize: 25,
                      )),
                  onSubmitted: (username) {
                    _isEmployeeIdValid =
                        this.widget._viewModelSignUp.employeeIdTextEditor.text.isNotEmpty;
                    _isNameValid = this.widget._viewModelSignUp.nameTextEditor.text.isNotEmpty;
                    _isPositionValid =
                        this.widget._viewModelSignUp.positionTextEditor.text.isNotEmpty;
                    _isManagerValid = this.widget._viewModelSignUp.managerTextEditor.text.isNotEmpty;
                    _isUsernameValid = username.isNotEmpty;
                    if (_isEmployeeIdValid &&
                        _isNameValid &&
                        _isPositionValid &&
                        _isManagerValid &&
                        _isUsernameValid) {
                      FocusScope.of(context).requestFocus(FocusNode());
                    }
                  },
                  controller: this.widget._viewModelSignUp.usernameTextEditor,
                ),
              ),
            ),
          ),
          SizedBox(height: 15),
          Container(
            height: 50.0,
            child: Material(
              borderRadius: BorderRadius.circular(10.0),
              shadowColor: Colors.grey,
              color: Colors.white,
              elevation: 7,
              child: Center(
                child: TextField(
                  obscureText: true,
                  maxLines: 1,
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(10, 15.0, 10, 15.0),
                      border: InputBorder.none,
                      errorText:
                          _isPasswordValid ? null : "Password can't be Empty",
                      hintText: 'Password',
                      labelStyle:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
                  onSubmitted: (password) {
                    _isEmployeeIdValid =
                        this.widget._viewModelSignUp.employeeIdTextEditor.text.isNotEmpty;
                    _isNameValid = this.widget._viewModelSignUp.nameTextEditor.text.isNotEmpty;
                    _isPositionValid =
                        this.widget._viewModelSignUp.positionTextEditor.text.isNotEmpty;
                    _isManagerValid = this.widget._viewModelSignUp.managerTextEditor.text.isNotEmpty;
                    _isUsernameValid =
                        this.widget._viewModelSignUp.usernameTextEditor.text.isNotEmpty;
                    _isPasswordValid = password.isNotEmpty;
                    if (_isEmployeeIdValid &&
                        _isNameValid &&
                        _isPositionValid &&
                        _isManagerValid &&
                        _isUsernameValid &&
                        _isPasswordValid) {
                      this.widget._presenterSignUp.doSignUp(
                          this.widget._viewSignUp, this.widget._viewModelSignUp
                      );
                    }
                  },
                  controller: this.widget._viewModelSignUp.passwordTextEditor,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 15,
          ),
          SizedBox(
              height: 50,
              width: mediaQuery.size.width,
              child: FlatButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                color: Colors.deepPurpleAccent,
                onPressed: () {
                  _isEmployeeIdValid =
                      this.widget._viewModelSignUp.employeeIdTextEditor.text.isNotEmpty;
                  _isNameValid = this.widget._viewModelSignUp.nameTextEditor.text.isNotEmpty;
                  _isPositionValid = this.widget._viewModelSignUp.positionTextEditor.text.isNotEmpty;
                  _isManagerValid = this.widget._viewModelSignUp.managerTextEditor.text.isNotEmpty;
                  _isUsernameValid = this.widget._viewModelSignUp.usernameTextEditor.text.isNotEmpty;
                  _isPasswordValid = this.widget._viewModelSignUp.passwordTextEditor.text.isNotEmpty;
                  if (_isEmployeeIdValid &&
                      _isNameValid &&
                      _isPositionValid &&
                      _isManagerValid &&
                      _isUsernameValid &&
                      _isPasswordValid) {
                    this.widget._presenterSignUp.doSignUp(
                      this.widget._viewSignUp, this.widget._viewModelSignUp
                    );
                  }
                },
                child: Text(
                  'SignUp',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              )),
        ],
      ),
    );
  }

}
