import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jus_mobile_order_app/Models/offers_model.dart';

class OffersServices {
  CollectionReference offersCollection =
      FirebaseFirestore.instance.collection('offers');

  Stream<List<OffersModel>> get offers {
    DateTime now = DateTime.now();
    return offersCollection
        .where('startDate',
            isGreaterThanOrEqualTo:
                DateTime(now.year, now.month, now.day, 0, 0, 0))
        .where('isActive', isEqualTo: true)
        .snapshots()
        .map(getOffersFromDatabase);
  }

  List<OffersModel> getOffersFromDatabase(QuerySnapshot snapshot) {
    return snapshot.docs.map(
      (doc) {
        final dynamic data = doc.data();
        return OffersModel(
          uid: data['uid'],
          name: data['name'],
          description: data['description'],
          startDate: data['startDate'].toDate(),
          endDate: data['endDate'].toDate(),
          itemLimit: data['itemLimit'],
          discount: data['discount'],
          pointsMultiple: data['pointsMultiple'].toDouble(),
          qualifyingProducts: data['qualifyingProducts'],
          qualifyingUsers: data['qualifyingUsers'],
          isMemberOnly: data['isMemberOnly'],
          isActive: data['isActive'],
        );
      },
    ).toList();
  }
}
