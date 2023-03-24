import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Models/location_model.dart';
import 'package:jus_mobile_order_app/Providers/ProviderWidgets/location_provider_widget.dart';
import 'package:jus_mobile_order_app/Providers/location_providers.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/outline_button_medium.dart';

class SearchButtonWidget extends HookConsumerWidget {
  const SearchButtonWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return LocationsProviderWidget(
      builder: (locations) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Align(
          alignment: Alignment.topLeft,
          child: MediumOutlineButton(
            onPressed: () {
              getCurrentBounds(ref, locations);
              ref.invalidate(selectedLocationProvider);
            },
            buttonText: 'Search this area',
          ),
        ),
      ),
    );
  }

  getCurrentBounds(WidgetRef ref, List<LocationModel> locations) async {
    final mapController = ref.read(googleMapControllerProvider);

    var mapBounds = LatLngBounds(
        southwest: const LatLng(0.0, 0.0), northeast: const LatLng(0.0, 0.0));
    if (mapController == null) {
      return null;
    } else {
      await mapController.getVisibleRegion();
      mapBounds = await mapController.getVisibleRegion();
      ref.read(currentMapBoundsProvider.notifier).state = mapBounds;
    }

    var listOfVisibleLocations = locations
        .where((element) =>
            mapBounds.contains(LatLng(element.latitude, element.longitude)))
        .toList();
    ref.read(locationsWithinMapBoundsProvider.notifier).state =
        listOfVisibleLocations;
  }
}
