import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import '../widgets/auth/auth_form.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;
  bool _isLoading = false;

  void showErrorDialog(String mes) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('An error occurred'),
            content: Text(
              mes,
              style: TextStyle(color: Colors.black),
            ),
            actions: [
              FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        });
  }

  void _submitFormAuth(String email, String username, String password,
      bool isLogin, File imgProfile) async {
    UserCredential res;
    var message = 'An error occurred, please check your credentials!';
    try {
      setState(() {
        _isLoading = true;
      });
      if (isLogin) {
        res = await _auth.signInWithEmailAndPassword(
            email: email, password: password);
      } else {
        res = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);

        final reference = FirebaseStorage.instance
            .ref()
            .child('user_image')
            .child(res.user.uid + 'jpg');
        await reference.putFile(imgProfile).whenComplete(() => null);

        final imgUrl = await reference.getDownloadURL();

        await FirebaseFirestore.instance
            .collection('users')
            .doc(res.user.uid)
            .set({
          'username': username,
          'email': email,
          'user_image': imgUrl,
        });
      }
    } on PlatformException catch (err) {
      if (err.message != null) {
        message = err.message;
      }
      showErrorDialog(message);
    } on FirebaseAuthException catch (err) {
      if (err.code == 'weak-password') {
        message = 'The password provided is too weak.';
        print(message);
      } else if (err.code == 'email-already-in-use') {
        message = 'The account already exists for that email.';
        print(message);
      } else if (err.code == 'user-not-found') {
        message = 'No user found for that email.';
        print(message);
      } else if (err.code == 'wrong-password') {
        message = 'Wrong password provided for that user.';
        print(message);
      }
      setState(() {
        _isLoading = false;
      });
      showErrorDialog(message);
    } catch (err) {
      print(err);
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AuthForm(_submitFormAuth, _isLoading);
  }
}
