import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class NewMessage extends StatefulWidget {
  @override
  _NewMessageState createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  var _enteredMessage = '';
  final _messageEditingController = TextEditingController();

  void _sendMyMessage() async {
    FocusScope.of(context).unfocus();
    final user = FirebaseAuth.instance.currentUser;
    final userData = await firestore.collection('users').doc(user.uid).get();
    firestore.collection('chat').add({
      'text': _enteredMessage,
      'createdAt': Timestamp.now(),
      'userId': user.uid,
      'username': userData['username'],
      'userImage': userData['user_image'],
    });
    _messageEditingController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.only(top: 10),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageEditingController,
              decoration: InputDecoration(
                hintText: 'send a message...',
                hintStyle: TextStyle(color: Colors.grey),
                focusColor: Colors.deepOrange,
                contentPadding:
                    EdgeInsets.symmetric(vertical: 10.0, horizontal: 10),
              ),
              autocorrect: true,
              textCapitalization: TextCapitalization.sentences,
              enableSuggestions: true,
              onChanged: (message) {
                setState(() {
                  _enteredMessage = message;
                });
              },
            ),
          ),
          IconButton(
              icon: Icon(Icons.send,color: Theme.of(context).accentColor,),
              onPressed:
                  _enteredMessage.trim().isEmpty ? null : _sendMyMessage),
        ],
      ),
    );
  }
}
