import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:jus_mobile_order_app/Helpers/enums.dart';
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
      SubscriptionStatus status =
          fromString(data['subscriptionStatus'] as String? ?? 'none');
      return UserModel(
        uid: data['uid'],
        firstName: data['firstName'],
        lastName: data['lastName'],
        email: data['email'],
        phone: data['phone'],
        subscriptionStatus: status,
        squareCustomerId: data['squareCustomerId'],
        points: data['points'],
      );
    } else {
      return const UserModel(
        uid: null,
        firstName: null,
        lastName: null,
        email: null,
        phone: null,
        subscriptionStatus: null,
        squareCustomerId: null,
        points: null,
      );
    }
  }

  Future<void> createUser({
    required uid,
    required String firstName,
    required String lastName,
    required String email,
    required String phone,
    required Map? subscription,
  }) async {
    await FirebaseFunctions.instance.httpsCallable('createUser').call({
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phone': phone,
      'uid': uid,
      'subscription': subscription,
    });
  }

  Future<Map<String, dynamic>> updateUser({
    required String firstName,
    required String lastName,
    required String phone,
    required String email,
    required String squareCustomerId,
  }) async {
    final response =
        await FirebaseFunctions.instance.httpsCallable('updateUserInfo').call({
      'uid': uid,
      'firstName': firstName,
      'lastName': lastName,
      'phone': phone,
      'email': email,
      'squareCustomerId': squareCustomerId,
    });

    return response.data as Map<String, dynamic>;
  }
}
