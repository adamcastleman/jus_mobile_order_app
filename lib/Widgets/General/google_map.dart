import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/error.dart';
import 'package:jus_mobile_order_app/Helpers/loading.dart';
import 'package:jus_mobile_order_app/Providers/location_providers.dart';
import 'package:jus_mobile_order_app/Providers/stream_providers.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/outline_button_medium.dart';

import '../../Models/location_model.dart';

class DisplayGoogleMap extends ConsumerStatefulWidget {
  const DisplayGoogleMap({Key? key}) : super(key: key);

  @override
  DisplayGoogleMapState createState() => DisplayGoogleMapState();
}

class DisplayGoogleMapState extends ConsumerState<DisplayGoogleMap> {
  final List<Marker> _markers = <Marker>[];
  String? _mapStyle;
  GoogleMapController? _mapController;
  BitmapDescriptor? customIcon;

  @override
  void initState() {
    rootBundle.loadString('assets/map_style.txt').then((string) {
      _mapStyle = string;
    });
    customMarker();
    super.initState();
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selectedLocationLatLong = ref.watch(currentLocationLatLongProvider);
    final locations = ref.watch(locationsProvider);

    return locations.when(
      loading: () => const Loading(),
      error: (e, _) => ShowError(
        error: e.toString(),
      ),
      data: (data) {
        _mapController?.animateCamera(CameraUpdate.newLatLng(
          LatLng(selectedLocationLatLong.latitude,
              selectedLocationLatLong.longitude),
        ));
        handleLocationMarkers(data);
        getCurrentBounds(data);
        return Stack(
          children: [
            GoogleMap(
              zoomControlsEnabled: true,
              tiltGesturesEnabled: false,
              initialCameraPosition: CameraPosition(
                bearing: 10.0,
                zoom: 11.0,
                target: LatLng(selectedLocationLatLong.latitude,
                    selectedLocationLatLong.longitude),
              ),
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              mapToolbarEnabled: false,
              markers: Set<Marker>.of(_markers),
              onMapCreated: (controller) => _onMapCreated(controller, data),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.topLeft,
                child: MediumOutlineButton(
                  onPressed: () {
                    getCurrentBounds(data);
                    ref.invalidate(selectedLocationProvider);
                  },
                  buttonText: 'Search this area',
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  getCurrentBounds(List<LocationModel> locations) async {
    var mapBounds = LatLngBounds(
        southwest: const LatLng(0.0, 0.0), northeast: const LatLng(0.0, 0.0));
    if (_mapController == null) {
      return null;
    } else {
      await _mapController!.getVisibleRegion();
      mapBounds = await _mapController!.getVisibleRegion();
      ref.read(currentMapBoundsProvider.notifier).state = mapBounds;
    }

    var listOfVisibleLocations = locations
        .where((element) =>
            mapBounds.contains(LatLng(element.latitude, element.longitude)))
        .toList();
    ref.read(locationsWithinMapBoundsProvider.notifier).state =
        listOfVisibleLocations;
  }

  void customMarker() async {
    customIcon = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(), 'assets/location_marker.png');
  }

  handleLocationMarkers(List<LocationModel> locations) async {
    for (var location in locations) {
      var selectedLocation = locations
          .where((element) =>
              element.latitude == location.latitude &&
              element.longitude == location.longitude)
          .first;
      _markers.add(
        Marker(
            icon: customIcon ?? BitmapDescriptor.defaultMarker,
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
              await getCurrentBounds(locations);
            }),
      );
    }
  }

  _onMapCreated(
      GoogleMapController controller, List<LocationModel> locations) async {
    if (mounted) {
      setState(() {
        _mapController = controller;
        controller.setMapStyle(_mapStyle);
      });

      await getCurrentBounds(locations);
    }
  }
}
