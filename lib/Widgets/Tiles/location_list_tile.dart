import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Models/location_model.dart';
import 'package:jus_mobile_order_app/Providers/location_providers.dart';
import 'package:jus_mobile_order_app/Views/store_details_page.dart';
import 'package:jus_mobile_order_app/Widgets/Helpers/formulas.dart';
import 'package:jus_mobile_order_app/Widgets/Helpers/modal_bottom_sheets.dart';
import 'package:jus_mobile_order_app/Widgets/Helpers/spacing_widgets.dart';
import 'package:jus_mobile_order_app/Widgets/Helpers/time.dart';

class LocationListTile extends ConsumerWidget {
  final int index;

  const LocationListTile({required this.index, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final visibleLocations = ref.watch(locationsWithinMapBoundsProvider);
    final selectedLocationId = ref.watch(selectedLocationID);
    final currentLocation = ref.watch(currentLocationProvider);

    return ListTile(
      shape: OutlineInputBorder(
        borderSide: BorderSide(
            color: determineBorderColor(selectedLocationId, visibleLocations),
            width: 0.5),
      ),
      tileColor: determineTileColor(selectedLocationId, visibleLocations),
      isThreeLine: true,
      title: Text(
        visibleLocations[index].name,
        style: Theme.of(context).textTheme.headline6,
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${visibleLocations[index].address['streetNumber']} ${visibleLocations[index].address['streetName']} ${visibleLocations[index].address['city']}',
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
          Row(
            children: [
              Text(
                  '${getDistanceFromCurrentLocation(visibleLocations[index], currentLocation)} mi. away'),
              Spacing().horizontal(10),
              openOrClosedText(visibleLocations),
            ],
          ),
        ],
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(
              FontAwesomeIcons.heart,
            ),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(
              FontAwesomeIcons.ellipsisVertical,
            ),
            onPressed: () {
              ModalBottomSheet().partScreen(
                  context: context,
                  enableDrag: true,
                  isDismissible: true,
                  builder: (context) =>
                      StoreDetailsPage(location: visibleLocations[index]));
            },
          ),
        ],
      ),
      onTap: () {
        ref.read(selectedLocationLatLongProvider.notifier).state = LatLng(
          visibleLocations[index].latitude,
          visibleLocations[index].longitude,
        );
        ref.read(selectedLocationID.notifier).state =
            visibleLocations[index].locationID;
        ref.read(locationSalesTaxRate.notifier).state =
            visibleLocations[index].salesTaxRate;
      },
    );
  }

  determineTileColor(int selectedLocation, List visibleLocations) {
    if (selectedLocation == visibleLocations[index].locationID) {
      return Colors.grey[100];
    } else {
      return Colors.white;
    }
  }

  determineBorderColor(int selectedLocation, List visibleLocations) {
    if (selectedLocation == visibleLocations[index].locationID) {
      return Colors.grey;
    } else {
      return Colors.white;
    }
  }

  openOrClosedText(List visibleLocations) {
    if (Time().locationOpenStatus(location: visibleLocations[index]) == true) {
      return const Text(
        'Open',
        style: TextStyle(color: Colors.green),
      );
    } else {
      return const Text(
        'Closed',
        style: TextStyle(color: Colors.red),
      );
    }
  }

  getDistanceFromCurrentLocation(
      LocationModel visibleLocation, LatLng currentLocation) {
    var distance = Geolocator.distanceBetween(
        visibleLocation.latitude,
        visibleLocation.longitude,
        currentLocation.latitude,
        currentLocation.longitude);
    return Formulas().metersToMiles(meters: distance);
  }
}
