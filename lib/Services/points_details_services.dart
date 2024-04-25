import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jus_mobile_order_app/Models/points_activity_model.dart';
import 'package:jus_mobile_order_app/Models/points_details_model.dart';

class PointsDetailsServices {
  String? userId;

  PointsDetailsServices({this.userId});

  CollectionReference pointsDetailsCollection =
      FirebaseFirestore.instance.collection('pointsDetails');

  CollectionReference pointsActivityCollection =
      FirebaseFirestore.instance.collection('pointsActivities');

  Stream<PointsDetailsModel> get pointsDetails {
    return pointsDetailsCollection
        .snapshots()
        .map(getPointsDetailsFromDatabase);
  }

  Stream<List<PointsActivityModel>> get pointsActivity {
    final DateTime hundredTwentyDaysAgo =
        DateTime.now().subtract(const Duration(days: 120));
    final int timestampLimit = hundredTwentyDaysAgo.millisecondsSinceEpoch;
    return pointsActivityCollection
        .where('userId', isEqualTo: userId)
        .where('timestamp', isGreaterThanOrEqualTo: timestampLimit)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map(getPointsActivitiesFromDatabase);
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

  List<PointsActivityModel> getPointsActivitiesFromDatabase(
      QuerySnapshot snapshot) {
    return snapshot.docs.map(
      (doc) {
        dynamic data = doc.data();
        return PointsActivityModel(
          userId: data['userId'],
          pointsEarned: data['pointsEarned'] ?? 0,
          pointsRedeemed: data['pointsRedeemed'] ?? 0,
          timestamp: data['timestamp'] ?? 0,
        );
      },
    ).toList();
  }
}
