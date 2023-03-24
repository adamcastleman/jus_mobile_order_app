import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMapWidget extends StatelessWidget {
  final LatLng initialLocation;
  final Set<Marker> markers;
  final Function(GoogleMapController) onMapCreated;

  const GoogleMapWidget({
    Key? key,
    required this.initialLocation,
    required this.markers,
    required this.onMapCreated,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      zoomControlsEnabled: true,
      tiltGesturesEnabled: false,
      initialCameraPosition: CameraPosition(
        bearing: 10.0,
        zoom: 11.0,
        target: initialLocation,
      ),
      myLocationEnabled: true,
      myLocationButtonEnabled: true,
      mapToolbarEnabled: false,
      markers: markers,
      onMapCreated: (controller) => onMapCreated(controller),
    );
  }
}
