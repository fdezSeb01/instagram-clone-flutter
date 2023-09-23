import "dart:typed_data";

import "package:firebase_auth/firebase_auth.dart";
import "package:firebase_storage/firebase_storage.dart";
import "package:flutter/material.dart";
import "package:uuid/uuid.dart";

class StorageMethods {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //add image to firebase stroage
  Future<String> uploadImage2Storage(
      String childName, Uint8List file, bool isPost) async {
    Reference ref = _storage.ref().child(childName).child(_auth.currentUser!
        .uid); //una carpeta que se llama como diga childName y adentro otro archvio con el id del usuario y adentro la imagen

    if (isPost) {
      String id = const Uuid().v1();
      ref = ref.child(
          id); //hace que el id del user sea una carpeta y el archivo dentro de esa carpeta sea el post id
      //osea queda Posts/userId/postId donde postId es la foto en bytes
    }
    UploadTask uploadTask = ref.putData(file);

    TaskSnapshot snap = await uploadTask;
    String download = await snap.ref.getDownloadURL();
    return download;
  }
}
