import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Models/location_model.dart';
import 'package:jus_mobile_order_app/Providers/location_providers.dart';

class MapBoundsUpdater {
  final WidgetRef _ref;

  MapBoundsUpdater(this._ref);

  Future<void> getCurrentBounds(
      GoogleMapController mapController, List<LocationModel> locations) async {
    var mapBounds = LatLngBounds(
        southwest: const LatLng(0.0, 0.0), northeast: const LatLng(0.0, 0.0));

    await mapController.getVisibleRegion();
    mapBounds = await mapController.getVisibleRegion();
    _ref.read(currentMapBoundsProvider.notifier).state = mapBounds;

    var listOfVisibleLocations = locations
        .where((element) =>
            mapBounds.contains(LatLng(element.latitude, element.longitude)))
        .toList();
    _ref.read(locationsWithinMapBoundsProvider.notifier).state =
        listOfVisibleLocations;
  }
}
