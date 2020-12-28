import 'dart:io';

import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';

class UserPhoto extends StatefulWidget {
  final void Function(File imgFile) pickPhotoFunc;

  UserPhoto(this.pickPhotoFunc);

  @override
  _UserPhotoState createState() => _UserPhotoState();
}

class _UserPhotoState extends State<UserPhoto> {
  File _imageFile;

  void _pickPhoto() async {
    final pickedPhoto = await ImagePicker().getImage(
        source: ImageSource.camera,
        maxHeight: 200,
        maxWidth: 200,
        imageQuality: 50);

    setState(() {
      _imageFile = File(pickedPhoto.path);
    });

    widget.pickPhotoFunc(_imageFile);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        CircleAvatar(
          radius: 60,
          backgroundColor: Colors.grey,
          backgroundImage: _imageFile != null
              ? FileImage(_imageFile)
              : AssetImage('assets/images/profile.png'),
        ),
        Positioned(
          right: 0,
          bottom: 0,
          child: Container(
            constraints: BoxConstraints(
              minWidth: 35,
              minHeight: 35,
            ),
            child: IconButton(
                icon: Icon(
                  Icons.camera_alt,
                  size: 35,
                  color: Colors.blue,
                ),
                onPressed: _pickPhoto),
          ),
        ),
      ],
    );
  }
}
