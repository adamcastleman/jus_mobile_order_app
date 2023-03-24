// map_initializers.dart

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Models/location_model.dart';
import 'package:jus_mobile_order_app/Providers/location_providers.dart';
import 'package:jus_mobile_order_app/Widgets/Map/map_bounds_manager.dart';

class MapInitializers {
  final WidgetRef ref;

  MapInitializers({required this.ref});

  Future<String> loadMapStyle(String assetPath) async {
    return await rootBundle.loadString(assetPath);
  }

  Future<BitmapDescriptor> createCustomMarker(String assetPath) async {
    return await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(),
      assetPath,
    );
  }

  void onMapCreated(
      GoogleMapController controller,
      ValueNotifier<String?> mapStyle,
      ValueNotifier<GoogleMapController?> mapController,
      List<LocationModel> locations) {
    ref.read(googleMapControllerProvider.notifier).state = controller;

    mapController.value = controller;
    controller.setMapStyle(mapStyle.value);
    MapBoundsUpdater(ref).getCurrentBounds(mapController.value!, locations);
  }

  void initialize({
    required ValueNotifier<String?> mapStyle,
    required ValueNotifier<BitmapDescriptor?> customIcon,
    required ValueNotifier<GoogleMapController?> mapController,
  }) {
    useEffect(() {
      loadMapStyle('assets/map_style.txt').then((string) {
        mapStyle.value = string;
      });
      createCustomMarker('assets/location_marker.png').then((icon) {
        customIcon.value = icon;
      });
      return () {
        mapController.value?.dispose();
      };
    }, const []);
  }
}
