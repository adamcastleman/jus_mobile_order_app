import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
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
    final selectedLocationLatLong = ref.watch(selectedLocationLatLongProvider);
    final locations = ref.watch(locationsProvider);
    _mapController?.animateCamera(CameraUpdate.newLatLng(
      LatLng(
          selectedLocationLatLong.latitude, selectedLocationLatLong.longitude),
    ));
    handleLocationMarkers(locations);
    getCurrentBounds(locations);

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
          onMapCreated: _onMapCreated,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Align(
            alignment: Alignment.topLeft,
            child: MediumOutlineButton(
              onPressed: () {
                getCurrentBounds(locations);
                ref.invalidate(selectedLocationID);
              },
              buttonText: 'Search this area',
            ),
          ),
        ),
      ],
    );
  }

  getCurrentBounds(AsyncValue<List<LocationModel>> locations) async {
    var mapBounds = LatLngBounds(
        southwest: const LatLng(0.0, 0.0), northeast: const LatLng(0.0, 0.0));
    if (_mapController == null) {
      return null;
    } else {
      await _mapController!.getVisibleRegion();
      mapBounds = await _mapController!.getVisibleRegion();
      ref.read(currentMapBoundsProvider.notifier).state = mapBounds;
    }
    var listOfVisibleLocations = locations.value!
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

  handleLocationMarkers(AsyncValue<List<LocationModel>> locations) async {
    for (var location in locations.value == null ? [] : locations.value!) {
      _markers.add(
        Marker(
            icon: customIcon ?? BitmapDescriptor.defaultMarker,
            markerId: MarkerId(location.name),
            position: LatLng(
              location.latitude,
              location.longitude,
            ),
            onTap: () {
              getCurrentBounds(locations);
              ref.read(selectedLocationID.notifier).state = location.locationID;
            }),
      );
    }
  }

  _onMapCreated(GoogleMapController controller) {
    if (mounted) {
      setState(() {
        _mapController = controller;
        controller.setMapStyle(_mapStyle);
      });
    }
  }
}
