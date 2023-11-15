import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Models/location_model.dart';
import 'package:jus_mobile_order_app/Providers/ProviderWidgets/location_provider_widget.dart';
import 'package:jus_mobile_order_app/Providers/location_providers.dart';
import 'package:jus_mobile_order_app/Widgets/Map/map_initializer.dart';
import 'package:jus_mobile_order_app/Widgets/Map/map_marker_handler.dart';
import 'package:jus_mobile_order_app/Widgets/Map/map_search_button_widget.dart';
import 'package:jus_mobile_order_app/Widgets/Map/map_widget.dart';

class DisplayGoogleMap extends HookConsumerWidget {
  const DisplayGoogleMap({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final markers = useState<List<Marker>>(<Marker>[]);
    final mapStyle = useState<String?>(null);
    final mapController = useState<GoogleMapController?>(null);
    final customIcon = useState<BitmapDescriptor?>(null);

    MapInitializers(ref: ref).initialize(
      mapStyle: mapStyle,
      customIcon: customIcon,
      mapController: mapController,
    );

    return LocationsProviderWidget(
      builder: (locations) {
        _handleMarkers(context, ref, mapController, locations, markers);

        return Stack(
          children: [
            Padding(
              padding:
                  const EdgeInsets.only(bottom: 18.0, left: 12.0, right: 12.0),
              child: _buildGoogleMapWidget(
                ref: ref,
                markers: Set<Marker>.of(markers.value),
                mapStyle: mapStyle,
                mapController: mapController,
                locations: locations,
              ),
            ),
            const SearchButtonWidget(),
          ],
        );
      },
    );
  }

  void _handleMarkers(
      BuildContext context,
      WidgetRef ref,
      ValueNotifier<GoogleMapController?> mapController,
      List<LocationModel> locations,
      ValueNotifier<List<Marker>> markers) {
    if (mapController.value != null) {
      MarkerHandler(
        context: context,
        ref: ref,
        mapController: mapController.value!,
        locations: locations,
      ).createMarkers().then((result) {
        markers.value = result;
      });
    }
  }

  Widget _buildGoogleMapWidget({
    required WidgetRef ref,
    required Set<Marker> markers,
    required ValueNotifier<String?> mapStyle,
    required ValueNotifier<GoogleMapController?> mapController,
    required List<LocationModel> locations,
  }) {
    final selectedLocationLatLong = ref.watch(currentLocationLatLongProvider);

    return GoogleMapWidget(
      initialLocation: LatLng(
        selectedLocationLatLong.latitude,
        selectedLocationLatLong.longitude,
      ),
      markers: markers,
      onMapCreated: (controller) {
        ref.read(googleMapControllerProvider.notifier).state = controller;
        MapInitializers(ref: ref).onMapCreated(
          controller,
          mapStyle,
          mapController,
          locations,
        );
      },
    );
  }
}
