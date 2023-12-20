import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/locations.dart';
import 'package:jus_mobile_order_app/Helpers/utilities.dart';
import 'package:jus_mobile_order_app/Models/location_model.dart';
import 'package:jus_mobile_order_app/Providers/location_providers.dart';
import 'package:jus_mobile_order_app/Services/location_services.dart';
import 'package:jus_mobile_order_app/Widgets/Map/map_marker_handler.dart';
import 'package:jus_mobile_order_app/constants.dart';

class DisplayGoogleMap extends HookConsumerWidget {
  const DisplayGoogleMap({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedLocationLatLong = ref.watch(currentLocationLatLongProvider);
    final mapStyle = useState<String?>(null);
    final markers = useState<Set<Marker>>({}); // State to store markers

    final mapController = useState<GoogleMapController?>(null);
    final customIcon = useState<BitmapDescriptor?>(null);
    double initialZoom = 0;
    if (PlatformUtils.isIOS() || PlatformUtils.isAndroid()) {
      initialZoom = 11.0;
    } else {
      initialZoom = 3.0;
    }

    useEffect(() {
      if (PlatformUtils.isIOS() || PlatformUtils.isAndroid()) {
        loadMapStyle('assets/map_style.txt').then((string) {
          mapStyle.value = string;
          if (mapController.value != null) {
            mapController.value!.setMapStyle(string);
          }
        });
      }

      createCustomMarker('assets/location_marker.png').then((icon) {
        customIcon.value = icon;
      });
      return () {
        mapController.value?.dispose();
      };
    }, const []);

    useEffect(() {
      if (selectedLocationLatLong != AppConstants.centerOfUS) {
        waitForMapControllerAndExecute(
            ref, mapController, selectedLocationLatLong, markers);
      }

      return null;
    }, [selectedLocationLatLong]);

    // When locationsWithinBounds updates, update the markers
    useEffect(
      () {
        _updateMarkers(ref, mapController, markers);
        return null; // No cleanup required
      },
      [ref.watch(locationsWithinMapBoundsProvider)],
    );

    return GoogleMap(
      padding: const EdgeInsets.only(left: 12.0, bottom: 18.0),
      zoomControlsEnabled: true,
      tiltGesturesEnabled: false,
      initialCameraPosition: CameraPosition(
        bearing: 10.0,
        zoom: initialZoom,
        target: LatLng(
          selectedLocationLatLong.latitude,
          selectedLocationLatLong.longitude,
        ),
      ),
      myLocationEnabled: true,
      myLocationButtonEnabled: false,
      mapToolbarEnabled: false,
      markers: markers.value,
      onMapCreated: (controller) {
        List<LocationModel> locationsWithinBounds;
        mapController.value = controller;
        ref.read(googleMapControllerProvider.notifier).state = controller;
        controller.setMapStyle(mapStyle.value);
        Future.delayed(
          const Duration(milliseconds: 100),
          () async {
            var mapBounds = await controller.getVisibleRegion();
            ref.read(currentMapBoundsProvider.notifier).state = mapBounds;
            double distance =
                LocationHelper().getMapBoundsDistanceInMeters(mapBounds);
            if (distance < AppConstants.oneHundredMilesInMeters) {
              locationsWithinBounds = await LocationServices()
                  .getLocationsWithinMapBounds(mapBounds);
              ref.read(locationsWithinMapBoundsProvider.notifier).state =
                  locationsWithinBounds;
              _handleMarkers(
                  ref, mapController, locationsWithinBounds, markers);
            } else {
              ref.invalidate(locationsWithinMapBoundsProvider);
            }
          },
        );
      },
    );
  }

  Future<String> loadMapStyle(String assetPath) async {
    return await rootBundle.loadString(assetPath);
  }

  Future<BitmapDescriptor> createCustomMarker(String assetPath) async {
    return await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(),
      assetPath,
    );
  }

  Future<void> waitForMapControllerAndExecute(
      WidgetRef ref,
      ValueNotifier<GoogleMapController?> mapController,
      LatLng selectedLocationLatLong,
      ValueNotifier<Set<Marker>> markers) async {
    while (mapController.value == null) {
      await Future.delayed(const Duration(milliseconds: 500));
    }
    // Now that the controller is not null, execute your code
    if (mapController.value != null) {
      mapController.value!.animateCamera(
        CameraUpdate.newLatLngZoom(
          LatLng(selectedLocationLatLong.latitude,
              selectedLocationLatLong.longitude),
          11.0,
        ),
      );
      LocationHelper().getCurrentBounds(ref);
      // Call to update markers here
      _updateMarkers(ref, mapController, markers);
    }
  }

  void _updateMarkers(
      WidgetRef ref,
      ValueNotifier<GoogleMapController?> mapController,
      ValueNotifier<Set<Marker>> markers) async {
    List<LocationModel> locations = ref.read(locationsWithinMapBoundsProvider);
    await _handleMarkers(ref, mapController, locations, markers);
    // Consider adding a state update here if necessary to refresh the map
  }

  Future<void> _handleMarkers(
      WidgetRef ref,
      ValueNotifier<GoogleMapController?> mapController,
      List<LocationModel> locations,
      ValueNotifier<Set<Marker>> markersNotifier) async {
    if (mapController.value != null) {
      var result = await MarkerHandler().createMarkers(
        ref,
        locations,
        mapController.value!,
      );
      markersNotifier.value = result.toSet();
    }
  }
}
