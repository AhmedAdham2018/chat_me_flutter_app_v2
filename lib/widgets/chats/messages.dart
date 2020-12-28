import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_app/widgets/chats/message_bubble.dart';

class Messages extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User>(
      stream: FirebaseAuth.instance.userChanges(),
      builder: (context, snapshotUser) {
        if (snapshotUser.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        return StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('chat')
              .orderBy('createdAt', descending: true)
              .snapshots(includeMetadataChanges: true),
          builder: (ctx, streamSnapshot) {
            if (streamSnapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            final documents = streamSnapshot.data.docs;
            return Padding(
              padding: const EdgeInsets.all(10.0),
              child: ListView.builder(
                reverse: true,
                itemCount: documents.length,
                itemBuilder: (ctx, index) => Container(
                  padding: EdgeInsets.all(8),
                  child: MessageBubble(
                    documents[index]['text'],
                    documents[index]['userId'] == snapshotUser.data.uid,
                    documents[index]['username'],
                    documents[index]['userImage'],
                    key: ValueKey(documents[index].id),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
