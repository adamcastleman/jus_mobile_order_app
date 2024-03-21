import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/locations.dart';
import 'package:jus_mobile_order_app/Models/location_model.dart';
import 'package:jus_mobile_order_app/Providers/controller_providers.dart';
import 'package:jus_mobile_order_app/Providers/location_providers.dart';
import 'package:jus_mobile_order_app/Services/location_services.dart';
import 'package:jus_mobile_order_app/Widgets/Map/map_marker_handler.dart';
import 'package:jus_mobile_order_app/constants.dart';

class DisplayGoogleMap extends HookConsumerWidget {
  const DisplayGoogleMap({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedLocationLatLong = ref.watch(currentLocationLatLongProvider);
    final mapController = ref.watch(googleMapControllerProvider);
    final mapStyle = useState<String?>(null);
    final markers = useState<Set<Marker>>({}); // State to store markers
    final customIcon = useState<BitmapDescriptor?>(null);
    double initialZoom = 0;
    if (selectedLocationLatLong == AppConstants.renoNV) {
      initialZoom = 11.0;
      // initialZoom = 3.0;
    } else {
      initialZoom = 11.0;
    }

    useEffect(() {
      if (selectedLocationLatLong != AppConstants.renoNV) {
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          await waitForMapControllerAndExecute(
              ref, mapController, selectedLocationLatLong, markers);
        });
      }
      _updateMarkers(ref, mapController, markers);

      return null;
    }, [selectedLocationLatLong]);

    useEffect(() {
      //This is the area where we could update the map theme
      createCustomMarker('assets/location_marker.png').then((icon) {
        customIcon.value = icon;
      });
      return () {
        mapController?.dispose();
      };
    }, const []);

    // When locationsWithinBounds updates, update the markers
    useEffect(
      () {
        _updateMarkers(ref, mapController, markers);
        return null; // No cleanup required
      },
      [ref.watch(locationsWithinMapBoundsProvider)],
    );

    return GoogleMap(
      padding: const EdgeInsets.only(top: 40.0, left: 12.0, bottom: 18.0),
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
      compassEnabled: false,
      markers: markers.value,
      onMapCreated: (controller) {
        List<LocationModel> locationsWithinBounds;
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
              await _handleMarkers(
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
      GoogleMapController? mapController,
      LatLng selectedLocationLatLong,
      ValueNotifier<Set<Marker>> markers) async {
    if (mapController != null) {
      await mapController.animateCamera(
        CameraUpdate.newLatLngZoom(
          LatLng(selectedLocationLatLong.latitude,
              selectedLocationLatLong.longitude),
          11.0,
        ),
      );
      await LocationHelper().getCurrentBounds(ref);
    }

    // Call to update markers here
  }

  void _updateMarkers(WidgetRef ref, GoogleMapController? mapController,
      ValueNotifier<Set<Marker>> markers) async {
    List<LocationModel> locations = ref.read(locationsWithinMapBoundsProvider);
    await _handleMarkers(ref, mapController, locations, markers);
    // Consider adding a state update here if necessary to refresh the map
  }

  Future<void> _handleMarkers(
      WidgetRef ref,
      GoogleMapController? mapController,
      List<LocationModel> locations,
      ValueNotifier<Set<Marker>> markersNotifier) async {
    if (mapController != null) {
      var result = await MarkerHandler().createMarkers(
        ref,
        locations,
        mapController,
      );
      markersNotifier.value = result.toSet();
    }
  }
}
