import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jus_mobile_order_app/Models/membership_details_model.dart';

class MembershipDetailsServices {
  final CollectionReference membershipDetailsCollection =
      FirebaseFirestore.instance.collection('membershipDetails');

  Stream<MembershipDetailsModel> get membershipDetails {
    return membershipDetailsCollection
        .snapshots()
        .map(getMembershipDetailsFromDatabase);
  }

  MembershipDetailsModel getMembershipDetailsFromDatabase(
      QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      final dynamic data = doc.data();
      return MembershipDetailsModel(
        uid: data['uid'],
        perks: data['perks'],
        subscriptionPrice: data['subscriptionPrice'],
        description: data['description'],
        signUpText: data['signUpText'],
        name: data['name'],
      );
    }).first;
  }
}
