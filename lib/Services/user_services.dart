import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jus_mobile_order_app/Models/user_model.dart';

class UserServices {
  String? uid;

  UserServices({this.uid});

  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

  Stream<UserModel> get user {
    return userCollection.doc(uid).snapshots().map(getCurrentUserFromDatabase);
  }

  UserModel getCurrentUserFromDatabase(DocumentSnapshot snapshot) {
    if (snapshot.exists) {
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      return UserModel(
        uid: data['uid'],
        firstName: data['firstName'],
        lastName: data['lastName'],
        email: data['email'],
        phone: data['phone'],
        isActiveMember: data['isActiveMember'],
        points: data['points'],
      );
    } else {
      return const UserModel(
        uid: null,
        firstName: null,
        lastName: null,
        email: null,
        phone: null,
        isActiveMember: null,
        points: null,
      );
    }
  }

  Future<void> createUser(
      {required uid,
      required String firstName,
      required String lastName,
      required String email,
      required String phone}) async {
    await userCollection.doc(uid).set({
      'uid': uid,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phone': phone,
      'points': 0,
      'isActiveMember': false,
    });
  }

  Future<void> updateUser({
    required String firstName,
    required String lastName,
    required String phone,
  }) async {
    await userCollection.doc(uid).update({
      'firstName': firstName,
      'lastName': lastName,
      'phone': phone,
    });
  }
}
