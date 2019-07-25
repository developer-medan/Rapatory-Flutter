import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rapatory_flutter/src/model/model_signup_screen.dart';
import 'package:rapatory_flutter/src/presenter/presenter_signup.dart';
import 'package:rapatory_flutter/src/view/view_signup.dart';
import 'package:rxdart/rxdart.dart';

class SignUpScreen extends StatefulWidget {
  final String title;
  final PresenterSignUp presenterSignUp;

  SignUpScreen(this.presenterSignUp, {this.title, Key key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen>
    with SingleTickerProviderStateMixin
    implements ViewSignUp {
  ModelSignUp _model;
  PublishSubject<bool> _publishSubjectLoading;

  @override
  void initState() {
    super.initState();
    this.widget.presenterSignUp.view = this;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _publishSubjectLoading.close();
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
            FormSignUp(this._model, widget.presenterSignUp),
            _buildWidgetLoadingScreen(),
          ],
        ),
      ),
    );
  }

  @override
  void refreshData(
      ModelSignUp model, PublishSubject<bool> publishSubjectLoading) {
    setState(() {
      this._model = model;
      this._publishSubjectLoading = publishSubjectLoading;
    });
  }

  Widget _buildWidgetLoadingScreen() {
    return StreamBuilder(
      stream: _publishSubjectLoading.stream,
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (snapshot.hasData) {
          bool isLoading = snapshot.data;
          if (isLoading) {
            return Container(
              width: double.infinity,
              height: double.infinity,
              child: Stack(
                children: <Widget>[
                  Container(
                    width: double.infinity,
                    height: double.infinity,
                    color: Color(0x90212121),
                  ),
                  Center(
                    child: Container(
                      width: 100.0,
                      height: 100.0,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0),
                          color: Colors.white),
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Platform.isIOS
                            ? CupertinoActivityIndicator()
                            : CircularProgressIndicator,
                      ),
                    ),
                  )
                ],
              ),
            );
          } else {
            return Container();
          }
        } else {
          return Container();
        }
      },
    );
  }
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
  final ModelSignUp _model;
  final PresenterSignUp _presenterSignUp;

  FormSignUp(this._model, this._presenterSignUp);

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
                  textInputAction: TextInputAction.newline,
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
                    setState(() => _isEmployeeIdValid = employeeId.isNotEmpty);
                    if (_isEmployeeIdValid) {
                      FocusScope.of(context).requestFocus(FocusNode());
                    }
                  },
                  controller: widget._model.employeeIdTextEditor,
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
                    setState(() => _isNameValid = name.isNotEmpty);
                    if (_isEmployeeIdValid && _isNameValid) {
                      FocusScope.of(context).requestFocus(FocusNode());
                    }
                  },
                  controller: widget._model.nameTextEditor,
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
                    setState(() {
                      _isEmployeeIdValid =
                          widget._model.employeeIdTextEditor.text.isNotEmpty;
                      _isNameValid =
                          widget._model.nameTextEditor.text.isNotEmpty;
                      _isPositionValid = position.isNotEmpty;
                    });
                    if (_isEmployeeIdValid &&
                        _isNameValid &&
                        _isPositionValid) {
                      FocusScope.of(context).requestFocus(FocusNode());
                    }
                  },
                  controller: widget._model.positionTextEditor,
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
                    setState(() {
                      _isEmployeeIdValid =
                          widget._model.employeeIdTextEditor.text.isNotEmpty;
                      _isNameValid =
                          widget._model.nameTextEditor.text.isNotEmpty;
                      _isPositionValid =
                          widget._model.positionTextEditor.text.isNotEmpty;
                      _isManagerValid = manager.isNotEmpty;
                    });
                    if (_isEmployeeIdValid &&
                        _isNameValid &&
                        _isPositionValid &&
                        _isManagerValid) {
                      FocusScope.of(context).requestFocus(FocusNode());
                    }
                  },
                  controller: widget._model.managerTextEditor,
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
                      hintText: 'username',
                      labelStyle: TextStyle(
                        fontSize: 25,
                      )),
                  onSubmitted: (username) {
                    setState(() {
                      _isEmployeeIdValid =
                          widget._model.employeeIdTextEditor.text.isNotEmpty;
                      _isNameValid =
                          widget._model.nameTextEditor.text.isNotEmpty;
                      _isPositionValid =
                          widget._model.positionTextEditor.text.isNotEmpty;
                      _isManagerValid =
                          widget._model.managerTextEditor.text.isNotEmpty;
                      _isUsernameValid = username.isNotEmpty;
                    });
                    if (_isEmployeeIdValid &&
                        _isNameValid &&
                        _isPositionValid &&
                        _isManagerValid &&
                        _isUsernameValid) {
                      FocusScope.of(context).requestFocus(FocusNode());
                    }
                  },
                  controller: widget._model.usernameTextEditor,
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
                    setState(() {
                      _isEmployeeIdValid =
                          widget._model.employeeIdTextEditor.text.isNotEmpty;
                      _isNameValid =
                          widget._model.nameTextEditor.text.isNotEmpty;
                      _isPositionValid =
                          widget._model.positionTextEditor.text.isNotEmpty;
                      _isManagerValid =
                          widget._model.managerTextEditor.text.isNotEmpty;
                      _isUsernameValid =
                          widget._model.usernameTextEditor.text.isNotEmpty;
                      _isPasswordValid = password.isNotEmpty;
                    });
                    if (_isEmployeeIdValid &&
                        _isNameValid &&
                        _isPositionValid &&
                        _isManagerValid &&
                        _isUsernameValid &&
                        _isPasswordValid) {
                      widget._presenterSignUp.doSignUp();
                    }
                  },
                  controller: widget._model.passwordTextEditor,
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
                  setState(() {
                    _isEmployeeIdValid =
                        widget._model.employeeIdTextEditor.text.isNotEmpty;
                    _isNameValid = widget._model.nameTextEditor.text.isNotEmpty;
                    _isPositionValid =
                        widget._model.positionTextEditor.text.isNotEmpty;
                    _isManagerValid =
                        widget._model.managerTextEditor.text.isNotEmpty;
                    _isUsernameValid =
                        widget._model.usernameTextEditor.text.isNotEmpty;
                    _isPasswordValid =
                        widget._model.passwordTextEditor.text.isNotEmpty;
                  });
                  if (_isEmployeeIdValid &&
                      _isNameValid &&
                      _isPositionValid &&
                      _isManagerValid &&
                      _isUsernameValid &&
                      _isPasswordValid) {
                    this.widget._presenterSignUp.doSignUp();
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
