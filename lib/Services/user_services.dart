import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:jus_mobile_order_app/Models/membership_stats_model.dart';
import 'package:jus_mobile_order_app/Models/user_model.dart';

class UserServices {
  String? uid;

  UserServices({this.uid});

  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

  Stream<UserModel> get user {
    return userCollection.doc(uid).snapshots().map(getCurrentUserFromDatabase);
  }

  Stream<MembershipStatsModel> get membershipStats {
    return userCollection
        .doc(uid)
        .collection('memberStatistics')
        .snapshots()
        .map(getMemberStatsFromDatabase);
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
        isActiveMember: null,
        squareCustomerId: null,
        points: null,
      );
    }
  }

  MembershipStatsModel getMemberStatsFromDatabase(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      final dynamic data = doc.data();
      return MembershipStatsModel(
        totalSaved: data['totalSaved'] ?? 0,
        bonusPoints: data['bonusPoints'] ?? 0,
      );
    }).first;
  }

  Future<HttpsCallableResult<dynamic>> createSquareSubscription({
    required String nonce,
    required String email,
    required String startDate,
  }) async {
    return await FirebaseFunctions.instance
        .httpsCallable('createSquareSubscription')
        .call({
      'nonce': nonce,
      'email': email,
      'startDate': startDate,
    });
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

  Future<void> updateUser({
    required String firstName,
    required String lastName,
    required String phone,
    required String email,
  }) async {
    await FirebaseFunctions.instance.httpsCallable('updateUserInfo').call({
      'firstName': firstName,
      'lastName': lastName,
      'phone': phone,
      'email': email,
    });
  }

  Future updateMembership(bool isActiveMember) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .update({'isActiveMember': !isActiveMember});
  }
}
