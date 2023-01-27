import 'package:cloud_firestore/cloud_firestore.dart';

class ImageServices {
  final collectionReference = FirebaseFirestore.instance.collection('images');

  Stream<dynamic> get emptyCartImage {
    return collectionReference.doc('emptyCart').snapshots();
  }
}
