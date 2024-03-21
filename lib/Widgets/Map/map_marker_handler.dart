import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/locations.dart';
import 'package:jus_mobile_order_app/Models/location_model.dart';
import 'package:jus_mobile_order_app/Providers/location_providers.dart';
import 'package:jus_mobile_order_app/Widgets/Map/map_bounds_manager.dart';
import 'package:jus_mobile_order_app/constants.dart';

class MarkerHandler {
  Future<List<Marker>> createMarkers(WidgetRef ref,
      List<LocationModel> locations, GoogleMapController controller) async {
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
              if (selectedLocation.status != AppConstants.comingSoon) {
                ref.read(selectedLocationProvider.notifier).state =
                    selectedLocation;
                // The following code is what controls the scrolling to the location
                //tile when tapping on the marker
                final index = locations.indexOf(selectedLocation);
                final tileWidth = AppConstants.tileWidth;
                LocationHelper().setLocationDataFromMap(ref, location);
                ref.read(selectedLocationIndexProvider.notifier).state = index;
                LocationHelper().calculateListScroll(
                  ref,
                  index,
                  tileWidth,
                );
                await MapBoundsUpdater(ref)
                    .getCurrentBounds(controller, locations);
              }
            }),
      );
    }
    return markers;
  }
}
