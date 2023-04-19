import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jus_mobile_order_app/Models/points_details_model.dart';

class PointsDetailsServices {
  CollectionReference pointsCollection =
      FirebaseFirestore.instance.collection('pointsDetails');

  Stream<PointsDetailsModel> get pointsDetails {
    return pointsCollection.snapshots().map(getPointsDetailsFromDatabase);
  }

  PointsDetailsModel getPointsDetailsFromDatabase(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      final dynamic data = doc.data();
      return PointsDetailsModel(
        uid: data['uid'],
        perks: data['perks'],
        name: data['name'],
        rewardsAmounts: data['rewardsAmounts'],
        pointsPerDollar: data['pointsPerDollar'],
        memberPointsPerDollar: data['memberPointsPerDollar'],
        walletPointsPerDollar: data['walletPointsPerDollar'],
        walletPointsPerDollarMember: data['walletPointsPerDollarMember'],
        pointsStatus: data['pointsStatus'],
        memberPointsStatus: data['memberPointsStatus'],
      );
    }).first;
  }
}
