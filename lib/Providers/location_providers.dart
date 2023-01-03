import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final currentLocationProvider =
    StateProvider<LatLng>((ref) => const LatLng(0.0, 0.0));

final selectedLocationLatLongProvider =
    StateProvider<LatLng>((ref) => const LatLng(0.0, 0.0));

final locationsWithinMapBoundsProvider = StateProvider<List>((ref) => []);

final currentMapBoundsProvider = StateProvider<LatLngBounds>((ref) =>
    LatLngBounds(
        northeast: const LatLng(0.0, 0.0), southwest: const LatLng(0.0, 0.0)));

final selectedLocationID = StateProvider<int>((ref) => 0);
