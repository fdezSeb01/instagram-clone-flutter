import "dart:typed_data";

import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:instagram_clone/resources/storage_methods.dart";

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //sign up
  Future<String> signUpUser({
    required String email,
    required String password,
    required String username,
    required String bio,
    required Uint8List file,
  }) async {
    String res = "Some error occured when signing up the user";
    try {
      if (email.isEmpty ||
          password.isEmpty ||
          username.isEmpty ||
          bio.isEmpty ||
          file == null) throw Error();
      //register user
      UserCredential cred = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      //add user to db
      //print(cred.user!.uid);

      String photo_url = await StorageMethods()
          .uploadImage2Storage('profilePics', file, false);

      //se usa doc.set para que firebas no cree un otro id y no coincidan
      await _firestore.collection('users').doc(cred.user!.uid).set({
        'username': username,
        'bio': bio,
        'email': email,
        'uid': cred.user!.uid,
        'followers': [],
        'following': [],
        'photoUrl': photo_url,
      });
      res = "Sucess";
    } on FirebaseAuthException catch (err) {
      if (err.code == 'invalid-email') {
        res = 'the email is badly formatted';
      } else if (err.code == 'weak-password') {
        res = 'the password is weak';
      } else {
        res = err.toString();
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> loginUser(
      {required String email, required String password}) async {
    String res = 'Some error ocurred';
    try {
      if (email.isEmpty || password.isEmpty) {
        res = 'email or passowrd are empty';
        return res;
      }
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      res = 'Success';
    } on FirebaseAuthException catch (err) {
      if (err.code == 'invalid-login-credentials') {
        res = 'Invalid username and/or passowrd';
        return res;
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }
}
