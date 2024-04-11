import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Models/location_model.dart';
import 'package:jus_mobile_order_app/constants.dart';

final allLocationsProvider = StateProvider<List<LocationModel>>((ref) => []);

final currentLocationLatLongProvider = StateProvider<LatLng>(
  (ref) => AppConstants.renoNV,
);

final locationsWithinMapBoundsProvider =
    StateProvider<List<LocationModel>>((ref) => []);

final currentMapBoundsProvider = StateProvider<LatLngBounds>(
  (ref) => LatLngBounds(
    northeast: const LatLng(0.0, 0.0),
    southwest: const LatLng(0.0, 0.0),
  ),
);

final selectedLocationProvider = StateProvider<LocationModel>(
  (ref) => const LocationModel(
    uid: '',
    name: '',
    locationId: '',
    squareLocationId: '',
    status: '',
    phone: '',
    address: {},
    hours: [],
    timezone: '',
    currency: '',
    geohash: '',
    latitude: 0,
    longitude: 0,
    isActive: false,
    isAcceptingOrders: false,
    salesTaxRate: 0,
    unavailableProducts: [],
    blackoutDates: [],
  ),
);

final selectedLocationIndexProvider = StateProvider<int>((ref) => 0);

final selectedLocationOpenTime =
    StateProvider<TimeOfDay>((ref) => const TimeOfDay(hour: 0, minute: 0));
final selectedLocationCloseTime =
    StateProvider<TimeOfDay>((ref) => const TimeOfDay(hour: 0, minute: 0));
