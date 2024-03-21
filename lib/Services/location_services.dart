import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dart_geohash/dart_geohash.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:jus_mobile_order_app/Models/location_model.dart';

class LocationServices {
  CollectionReference locationsCollection =
      FirebaseFirestore.instance.collection('locations');

  Stream<List<LocationModel>> get locations {
    return locationsCollection.snapshots().map(getLocationDataFromDatabase);
  }

  Future<List<LocationModel>> getLocationsWithinMapBounds(
      LatLngBounds mapBounds) async {
    final geohash = GeoHasher();
    String neGeohash = geohash.encode(
        mapBounds.northeast.longitude, mapBounds.northeast.latitude);
    String swGeohash = geohash.encode(
        mapBounds.southwest.longitude, mapBounds.southwest.latitude);

    var querySnapshot = await FirebaseFirestore.instance
        .collection('locations')
        .where('geohash', isGreaterThanOrEqualTo: swGeohash)
        .where('geohash', isLessThanOrEqualTo: neGeohash)
        .get();

    return getLocationDataFromDatabase(querySnapshot);
  }

  Future<LocationModel> getLocationFromLocationID(int locationId) async {
    var querySnapshot = await FirebaseFirestore.instance
        .collection('locations')
        .where('locationId', isEqualTo: locationId)
        .get();

    return getLocationDataFromDatabase(querySnapshot).first;
  }

  List<LocationModel> getLocationDataFromDatabase(QuerySnapshot snapshot) {
    return snapshot.docs.map(
      (doc) {
        final dynamic data = doc.data();
        return LocationModel(
          uid: data['uid'],
          name: data['name'],
          status: data['status'],
          locationId: data['locationId'],
          squareLocationId: data['squareLocationId'],
          phone: data['phone'],
          address: data['address'],
          hours: data['hours'],
          timezone: data['timezone'],
          currency: data['currency'],
          geohash: data['geohash'],
          latitude: data['latitude'],
          longitude: data['longitude'],
          isActive: data['isActive'],
          isAcceptingOrders: data['isAcceptingOrders'],
          salesTaxRate: data['salesTaxRate'],
          unavailableProducts: data['unavailableProducts'],
          blackoutDates: data['blackoutDates'],
        );
      },
    ).toList();
  }
}
