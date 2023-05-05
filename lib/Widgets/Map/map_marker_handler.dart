import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Models/location_model.dart';
import 'package:jus_mobile_order_app/Providers/location_providers.dart';
import 'package:jus_mobile_order_app/Widgets/Map/map_bounds_manager.dart';

class MarkerHandler {
  final WidgetRef ref;
  final GoogleMapController mapController;
  final List<LocationModel> locations;

  MarkerHandler({
    required this.ref,
    required this.mapController,
    required this.locations,
  });

  Future<List<Marker>> createMarkers() async {
    List<Marker> markers = [];

    for (var location in locations) {
      var selectedLocation = locations
          .where((element) =>
              element.latitude == location.latitude &&
              element.longitude == location.longitude)
          .first;

      BitmapDescriptor icon = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(),
        'assets/location_marker.png',
      );

      markers.add(
        Marker(
            icon: icon,
            markerId: MarkerId(location.name),
            position: LatLng(
              location.latitude,
              location.longitude,
            ),
            onTap: () async {
              HapticFeedback.lightImpact();
              selectedLocation.comingSoon
                  ? null
                  : ref.read(selectedLocationProvider.notifier).state =
                      selectedLocation;
              await MapBoundsUpdater(ref)
                  .getCurrentBounds(mapController, locations);
            }),
      );
    }
    return markers;
  }
}
