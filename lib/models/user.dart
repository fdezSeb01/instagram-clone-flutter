import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String email;
  final String uid;
  final String photoUrl;
  final String bio;
  final String username;
  final List followers;
  final List following;

  const User({
    required this.email,
    required this.uid,
    required this.photoUrl,
    required this.username,
    required this.bio,
    required this.followers,
    required this.following,
  });

  Map<String, dynamic> toJson() => {
        "username": username,
        'uid': uid,
        'email': email,
        'photoUrl': photoUrl,
        'bio': bio,
        'followers': followers,
        'following': following,
      };

  static User fromSnap(DocumentSnapshot snaphot) {
    var snap = snaphot.data() as Map<String, dynamic>;

    return User(
      username: snaphot['username'],
      uid: snaphot['uid'],
      email: snaphot['email'],
      photoUrl: snaphot['photoUrl'],
      bio: snaphot['bio'],
      followers: snaphot['followers'],
      following: snaphot['following'],
    );
  }
}
