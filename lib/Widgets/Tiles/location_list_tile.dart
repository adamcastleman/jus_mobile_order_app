import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/formulas.dart';
import 'package:jus_mobile_order_app/Helpers/modal_bottom_sheets.dart';
import 'package:jus_mobile_order_app/Helpers/spacing_widgets.dart';
import 'package:jus_mobile_order_app/Helpers/time.dart';
import 'package:jus_mobile_order_app/Models/location_model.dart';
import 'package:jus_mobile_order_app/Providers/location_providers.dart';
import 'package:jus_mobile_order_app/Providers/theme_providers.dart';
import 'package:jus_mobile_order_app/Sheets/store_details_sheet.dart';

class LocationListTile extends ConsumerWidget {
  final int index;

  const LocationListTile({required this.index, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final visibleLocations = ref.watch(locationsWithinMapBoundsProvider);
    final currentLocation = ref.watch(currentLocationLatLongProvider);
    final selectedLocation = ref.watch(selectedLocationProvider);

    return ListTile(
      shape: OutlineInputBorder(
        borderSide: BorderSide(
            color:
                determineBorderColor(ref, selectedLocation, visibleLocations),
            width: 0.5),
      ),
      tileColor: determineTileColor(ref, selectedLocation, visibleLocations),
      isThreeLine: true,
      title: Row(
        children: [
          Text(
            visibleLocations[index].name,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          visibleLocations[index].comingSoon
              ? Text(
                  ' - Coming Soon',
                  style: Theme.of(context).textTheme.titleLarge,
                )
              : const SizedBox(),
        ],
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
              openOrClosedText(ref, visibleLocations),
            ],
          ),
          Spacing().vertical(10),
          acceptingOrdersText(visibleLocations, context, ref),
        ],
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          visibleLocations[index].comingSoon
              ? const SizedBox()
              : IconButton(
                  icon: const Icon(
                    FontAwesomeIcons.ellipsisVertical,
                  ),
                  onPressed: () {
                    var location = visibleLocations[index];
                    setLocationData(ref, location);
                    ModalBottomSheet().partScreen(
                      context: context,
                      enableDrag: true,
                      isDismissible: true,
                      builder: (context) => const StoreDetailsSheet(),
                    );
                  },
                ),
        ],
      ),
      onTap: () {
        HapticFeedback.lightImpact();
        var location = visibleLocations[index];
        setLocationData(ref, location);
      },
    );
  }

  determineTileColor(
      WidgetRef ref, dynamic selectedLocation, List visibleLocations) {
    final selectedCardColor = ref.watch(selectedCardColorProvider);
    if (selectedLocation == null) {
      return Colors.white;
    }
    return selectedLocation.locationID == visibleLocations[index].locationID
        ? selectedCardColor
        : Colors.white;
  }

  determineBorderColor(
      WidgetRef ref, dynamic selectedLocation, List visibleLocations) {
    final selectedCardBorderColor = ref.watch(selectedCardBorderColorProvider);
    if (selectedLocation == null) {
      return Colors.white;
    }
    return selectedLocation.locationID == visibleLocations[index].locationID
        ? selectedCardBorderColor
        : Colors.white;
  }

  openOrClosedText(WidgetRef ref, List visibleLocations) {
    if (Time().isLocationClosingSoon(visibleLocations[index])) {
      return const Text(
        'Closing Soon',
        style: TextStyle(color: Colors.deepOrangeAccent),
      );
    }
    if (Time().isLocationOpen(location: visibleLocations[index])) {
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

  acceptingOrdersText(
      List visibleLocations, BuildContext context, WidgetRef ref) {
    if (visibleLocations[index].acceptingOrders ||
        !Time().isLocationOpen(location: visibleLocations[index])) {
      return const SizedBox();
    } else {
      return const Text(
        'This location is currently not accepting pickup orders',
        style: TextStyle(fontSize: 10, color: Colors.red),
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

  setLocationData(WidgetRef ref, LocationModel location) {
    if (location.comingSoon) {
      return null;
    } else {
      setSelectedLocation(ref, location);
      setLatAndLongOfLocation(ref, location);
      setOpenAndCloseTime(ref, location);
    }
  }

  setLatAndLongOfLocation(WidgetRef ref, location) {
    ref.read(currentLocationLatLongProvider.notifier).state =
        LatLng(location.latitude, location.longitude);
  }

  setOpenAndCloseTime(WidgetRef ref, location) {
    var openTime = location.hours[DateTime.now().weekday - 1]['open'];
    ref.read(selectedLocationOpenTime.notifier).state = TimeOfDay(
      hour: int.parse(openTime.substring(0, openTime.indexOf(':'))),
      minute: int.parse(openTime.substring(openTime.indexOf(':') + 1)),
    );
    var closeTime = location.hours[DateTime.now().weekday - 1]['close'];
    ref.read(selectedLocationCloseTime.notifier).state = TimeOfDay(
      hour: int.parse(closeTime.substring(0, 2)),
      minute: int.parse(closeTime.substring(3)),
    );
  }

  setSelectedLocation(WidgetRef ref, location) {
    ref.read(selectedLocationProvider.notifier).state = location;
  }
}
