import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_app/constants.dart';
import '../picker/image_picker.dart';

class AuthForm extends StatefulWidget {
  final void Function(
    String email,
    String username,
    String password,
    bool isLogin,
    File imgProfile,
  ) submitAuthFunc;
  final isLoading;

  AuthForm(this.submitAuthFunc, this.isLoading);

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  var _isLogin = true;
  var _email = '';
  var _username = '';
  var _password = '';
  File _imageFile;

  void _pickedPhoto(File imgPicked) {
    _imageFile = imgPicked;
  }

  void _trySubmit() {
    final isValid = _formKey.currentState.validate();

    FocusScope.of(context).unfocus();

    if (_imageFile == null && !_isLogin) {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text('Please pick an image.'),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
      return;
    }

    if (isValid) {
      _formKey.currentState.save();

      widget.submitAuthFunc(_email, _username, _password, _isLogin, _imageFile);
      print(_email);
      print(_password);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Chat Me',
          style: kAppBarTextStyle,
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding:
            const EdgeInsets.only(top: 60, left: 15, right: 15, bottom: 15),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                if (!_isLogin) UserPhoto(_pickedPhoto),
                SizedBox(
                  height: 40,
                ),
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  key: ValueKey('email'),
                  onSaved: (email) {
                    _email = email.trim();
                  },
                  decoration: kTextEditingDecoration.copyWith(
                      hintText: 'Email Address'),
                  validator: (email) {
                    if (email.isEmpty || !email.contains('@')) {
                      return 'Your email address not valid.';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 15,
                ),
                if (!_isLogin)
                  TextFormField(
                    key: ValueKey('username'),
                    onSaved: (username) {
                      _username = username.trim();
                    },
                    decoration:
                        kTextEditingDecoration.copyWith(hintText: 'Username'),
                    validator: (username) {
                      if (username.isEmpty || username.length < 5) {
                        return 'Please enter a valid username.';
                      }
                      return null;
                    },
                  ),
                SizedBox(
                  height: 15,
                ),
                TextFormField(
                  obscureText: true,
                  key: ValueKey('password'),
                  onSaved: (password) {
                    _password = password.trim();
                  },
                  decoration:
                      kTextEditingDecoration.copyWith(hintText: 'Password'),
                  validator: (password) {
                    if (password.isEmpty || password.length < 7) {
                      return 'Please enter a valid password.';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 15,
                ),
                if (widget.isLoading) CircularProgressIndicator(),
                if (!widget.isLoading)
                  RaisedButton(
                      child: Text(_isLogin ? 'Login' : 'Register'),
                      onPressed: _trySubmit),
                SizedBox(
                  height: 15,
                ),
                if (!widget.isLoading)
                  RaisedButton(
                      child: Text(_isLogin
                          ? 'Create an account'
                          : 'I already have an account'),
                      onPressed: () {
                        setState(() {
                          _isLogin = !_isLogin;
                        });
                      }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
