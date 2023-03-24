import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final currentLocationLatLongProvider =
    StateProvider<LatLng>((ref) => const LatLng(0.0, 0.0));

final locationsWithinMapBoundsProvider = StateProvider<List>((ref) => []);

final googleMapControllerProvider =
    StateProvider<GoogleMapController?>((ref) => null);

final currentMapBoundsProvider = StateProvider<LatLngBounds>(
  (ref) => LatLngBounds(
    northeast: const LatLng(0.0, 0.0),
    southwest: const LatLng(0.0, 0.0),
  ),
);

final selectedLocationProvider = StateProvider<dynamic>((ref) => null);

final selectedLocationOpenTime =
    StateProvider<TimeOfDay>((ref) => const TimeOfDay(hour: 0, minute: 0));
final selectedLocationCloseTime =
    StateProvider<TimeOfDay>((ref) => const TimeOfDay(hour: 0, minute: 0));
