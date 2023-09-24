import 'dart:js_interop';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram_clone/models/comment.dart';
import 'package:instagram_clone/models/post.dart';
import 'package:instagram_clone/models/user.dart';
import 'package:instagram_clone/resources/storage_methods.dart';
import 'package:instagram_clone/utils/utils.dart';
import 'package:uuid/uuid.dart';

class FirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //upload post
  Future<String> uploadPost(String descr, Uint8List file, String uid,
      String username, String pp) async {
    String res = "Some error ocurred when uploading the post";
    try {
      String photoUrl =
          await StorageMethods().uploadImage2Storage('posts', file, true);

      String postId = const Uuid().v1();
      Post post = Post(
        description: descr,
        uid: uid,
        username: username,
        postId: postId,
        datePublished: DateTime.now(),
        postUrl: photoUrl,
        profImage: pp,
        likes: [],
      );
      _firestore.collection('posts').doc(postId).set(post.toJson());
      res = 'Success';
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  Future<void> likePost(
      String postId, String uid, List likes, bool isSmallLike) async {
    try {
      if (likes.contains(uid)) {
        if (!isSmallLike) return;
        likes.remove(uid);
      } else {
        likes.add(uid);
      }
      await _firestore.collection('posts').doc(postId).update({
        'likes': likes,
      });
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> commentPost(
    String uid,
    String profImage,
    String username,
    String comment,
    String postId,
  ) async {
    try {
      String id = const Uuid().v1();
      Comment com = Comment(
        comment: comment,
        uid: uid,
        username: username,
        commentId: id,
        profImage: profImage,
      );
      await _firestore
          .collection('posts')
          .doc(postId)
          .collection('comments')
          .doc(id)
          .set(com.toJson());
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> deletePost(String postId) async {
    try {
      await _firestore.collection('posts').doc(postId).delete();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> FollowUser(String uid, String followId) async {
    try {
      User user =
          User.fromSnap(await _firestore.collection('users').doc(uid).get());
      User followuser = User.fromSnap(
          await _firestore.collection('users').doc(followId).get());

      if (user.following.contains(followId)) {
        user.following.remove(followId);
        followuser.followers.remove(uid);
      } else {
        user.following.add(followId);
        followuser.followers.add(uid);
      }

      await _firestore.collection('users').doc(uid).update(
        {'following': user.following},
      );
      await _firestore.collection('users').doc(followId).update(
        {'followers': followuser.followers},
      );
    } catch (e) {
      print(e.toString());
    }
  }
}
