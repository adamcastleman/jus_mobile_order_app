import 'package:cloud_firestore/cloud_firestore.dart';

class ImageServices {
  final collectionReference = FirebaseFirestore.instance.collection('images');

  Stream<dynamic> get emptyCartImage {
    return collectionReference.doc('emptyCart').snapshots();
  }

  Stream<dynamic> get signInImage {
    return collectionReference.doc('signIn').snapshots();
  }

  Stream<dynamic> get deleteAccount {
    return collectionReference.doc('deleteAccount').snapshots();
  }

  Stream<dynamic> get displayImages {
    return collectionReference.doc('displayImages').snapshots();
  }
}
