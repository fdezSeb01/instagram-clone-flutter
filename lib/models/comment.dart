import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  final String comment;
  final String uid;
  final String username;
  final String profImage;
  final String commentId;
  final List likes;

  const Comment({
    required this.comment,
    required this.uid,
    required this.username,
    required this.commentId,
    required this.profImage,
    this.likes = const [],
  });

  Map<String, dynamic> toJson() => {
        'comment': comment,
        'uid': uid,
        'username': username,
        'commentId': commentId,
        'profImage': profImage,
        'likes': likes,
      };

  static Comment fromSnap(DocumentSnapshot snaphot) {
    var snap = snaphot.data() as Map<String, dynamic>;

    return Comment(
      comment: snap['comment'],
      uid: snap['uid'],
      username: snap['username'],
      commentId: snap['commentId'],
      profImage: snap['profImage'],
      likes: snap['likes'],
    );
  }
}
