import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jus_mobile_order_app/Models/offers_model.dart';

class OffersServices {
  CollectionReference offersCollection =
      FirebaseFirestore.instance.collection('offers');

  Stream<List<OffersModel>> get offers {
    return offersCollection
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
          itemLimit: data['itemLimit'],
          discount: data['discount'],
          pointsMultiple: data['pointsMultiple'].toDouble(),
          qualifyingProducts: data['qualifyingProducts'],
          isMemberOnly: data['isMemberOnly'],
          isActive: data['isActive'],
          qualifyingUsers: data['qualifyingUsers'],
        );
      },
    ).toList();
  }
}
