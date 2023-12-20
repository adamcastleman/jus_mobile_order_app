import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/formulas.dart';
import 'package:jus_mobile_order_app/Helpers/locations.dart';
import 'package:jus_mobile_order_app/Helpers/modal_bottom_sheets.dart';
import 'package:jus_mobile_order_app/Helpers/spacing_widgets.dart';
import 'package:jus_mobile_order_app/Helpers/time.dart';
import 'package:jus_mobile_order_app/Helpers/utilities.dart';
import 'package:jus_mobile_order_app/Models/location_model.dart';
import 'package:jus_mobile_order_app/Providers/location_providers.dart';
import 'package:jus_mobile_order_app/Providers/theme_providers.dart';
import 'package:jus_mobile_order_app/Sheets/store_details_sheet.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/order_here_button.dart';
import 'package:jus_mobile_order_app/constants.dart';

class LocationListTile extends ConsumerWidget {
  final double tileWidth;
  final int index;

  const LocationListTile(
      {required this.tileWidth, required this.index, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final visibleLocations = ref.watch(locationsWithinMapBoundsProvider);
    final selectedLocation = ref.watch(selectedLocationProvider);
    final mapController = ref.read(googleMapControllerProvider);
    final titleStyle = ref.watch(titleStyleProvider);
    final subtitleStyle = ref.watch(subtitleStyleProvider);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: determineBorderColor(ref, selectedLocation, visibleLocations),
          width: 0.5,
        ),
        color: determineTileColor(ref, selectedLocation, visibleLocations),
      ),
      width: tileWidth,
      child: Column(
        children: [
          ListTile(
            isThreeLine: true,
            title: Row(
              children: [
                AutoSizeText(
                  visibleLocations[index].name,
                  style: titleStyle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                visibleLocations[index].status == AppConstants.comingSoon
                    ? AutoSizeText(
                        ' - Coming Soon',
                        style: titleStyle,
                        overflow: TextOverflow.ellipsis,
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
                  style: subtitleStyle,
                ),
                Row(
                  children: [
                    displayMilesAwayText(visibleLocations, subtitleStyle),
                    Spacing.horizontal(10),
                    openOrClosedText(ref, visibleLocations),
                  ],
                ),
                Spacing.vertical(10),
                acceptingOrdersText(visibleLocations, context, ref),
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                visibleLocations[index].status == AppConstants.comingSoon
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
              ref.read(currentLocationLatLongProvider.notifier).state =
                  LatLng(location.latitude, location.longitude);
              setLocationData(ref, location);
              _animateCameraToMarker(ref, mapController!);
              PlatformUtils.isIOS() || PlatformUtils.isAndroid()
                  ? LocationHelper().calculateListScroll(ref, index, tileWidth)
                  : null;
            },
          ),
          selectedLocation == null ||
                  selectedLocation.locationID !=
                      visibleLocations[index].locationID
              ? const SizedBox()
              : Padding(
                  padding: const EdgeInsets.only(right: 12.0),
                  child: Align(
                      alignment: Alignment.bottomRight,
                      child: PlatformUtils.isIOS() || PlatformUtils.isAndroid()
                          ? const OrderHereButton()
                          : Container(
                              width: 130,
                              padding: const EdgeInsets.only(bottom: 10.0),
                              child: const OrderHereButton(),
                            )),
                )
        ],
      ),
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

  Widget openOrClosedText(WidgetRef ref, List<LocationModel> visibleLocations) {
    // Define styles for different states
    const TextStyle closedStyle = TextStyle(fontSize: 12, color: Colors.red);
    const TextStyle closingSoonStyle =
        TextStyle(color: Colors.deepOrangeAccent);
    const TextStyle openStyle = TextStyle(fontSize: 12, color: Colors.green);

    // Retrieve the current location status
    final String status = visibleLocations[index].status;

    // Determine the appropriate text and style based on status
    String text;
    TextStyle style;
    if (status == AppConstants.comingSoon ||
        !Time().isLocationOpen(location: visibleLocations[index])) {
      text = 'Closed';
      style = closedStyle;
    } else if (Time().isLocationClosingSoon(visibleLocations[index])) {
      text = 'Closing Soon';
      style = closingSoonStyle;
    } else {
      text = 'Open';
      style = openStyle;
    }

    // Return the text widget
    return AutoSizeText(
      text,
      style: style,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget acceptingOrdersText(
      List visibleLocations, BuildContext context, WidgetRef ref) {
    if (visibleLocations[index].acceptingOrders ||
        !Time().isLocationOpen(location: visibleLocations[index])) {
      return const SizedBox();
    } else {
      return const AutoSizeText(
        'This location is currently not accepting pickup orders',
        style: TextStyle(fontSize: 10, color: Colors.red),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      );
    }
  }

  Future<double> getDistanceFromCurrentLocation(
      LocationModel visibleLocation) async {
    // Fetch the current position
    Position currentPosition = await Geolocator.getCurrentPosition();

    // Calculate the distance
    var distance = Geolocator.distanceBetween(
        visibleLocation.latitude,
        visibleLocation.longitude,
        currentPosition.latitude,
        currentPosition.longitude);

    var distanceInMiles = Formulas().metersToMiles(meters: distance);

    return distanceInMiles;
  }

  displayMilesAwayText(List<LocationModel> visibleLocations, subtitleStyle) {
    return FutureBuilder(
      future: getDistanceFromCurrentLocation(visibleLocations[index]),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Text('');
        }
        return AutoSizeText(
          '${snapshot.data} mi. away',
          style: subtitleStyle,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        );
      },
    );
  }

  setLocationData(WidgetRef ref, LocationModel location) {
    if (location.status == AppConstants.comingSoon) {
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

  _animateCameraToMarker(WidgetRef ref, GoogleMapController mapController) {
    mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: ref.watch(currentLocationLatLongProvider),
          zoom: 11.0,
        ),
      ),
    );
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
