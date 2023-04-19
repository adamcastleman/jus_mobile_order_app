import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jus_mobile_order_app/Models/location_model.dart';

class LocationServices {
  CollectionReference locationsCollection =
      FirebaseFirestore.instance.collection('locations');

  Stream<List<LocationModel>> get locations {
    return locationsCollection.snapshots().map(getLocationDataFromDatabase);
  }

  List<LocationModel> getLocationDataFromDatabase(QuerySnapshot snapshot) {
    return snapshot.docs.map(
      (doc) {
        final dynamic data = doc.data();
        return LocationModel(
          uid: data['uid'],
          name: data['name'],
          locationID: data['locationID'],
          phone: data['phone'],
          address: data['address'],
          hours: data['hours'],
          timezone: data['timezone'],
          currency: data['currency'],
          latitude: data['latitude'],
          longitude: data['longitude'],
          isActive: data['isActive'],
          isAcceptingOrders: data['isAcceptingOrders'],
          salesTaxRate: data['salesTaxRate'],
          acceptingOrders: data['acceptingOrders'],
          unavailableProducts: data['unavailableProducts'],
          comingSoon: data['comingSoon'],
          blackoutDates: data['blackoutDates'],
        );
      },
    ).toList();
  }
}
