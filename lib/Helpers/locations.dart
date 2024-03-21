import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/modal_sheets.dart';
import 'package:jus_mobile_order_app/Helpers/permission_handler.dart';
import 'package:jus_mobile_order_app/Models/location_model.dart';
import 'package:jus_mobile_order_app/Models/product_model.dart';
import 'package:jus_mobile_order_app/Providers/controller_providers.dart';
import 'package:jus_mobile_order_app/Services/location_services.dart';
import 'package:jus_mobile_order_app/constants.dart';

import '../Providers/location_providers.dart';
import '../Views/location_page_mobile.dart';

class LocationHelper {
  selectedLocation(WidgetRef ref) {
    final location = ref.watch(selectedLocationProvider);
    final locations = ref.watch(allLocationsProvider);
    if (location.uid.isEmpty) {
      return null;
    }
    return locations
        .where((element) => element.locationId == location.locationId)
        .first;
  }

  bool isProductInStock(WidgetRef ref, ProductModel product) {
    return LocationHelper().selectedLocation(ref) == null ||
        !LocationHelper()
            .selectedLocation(ref)
            .unavailableProducts
            .contains(product.productId);
  }

  acceptingOrders(WidgetRef ref) {
    final location = ref.watch(selectedLocationProvider);
    final locations = ref.watch(allLocationsProvider);
    if (location.uid.isEmpty) {
      return null;
    }
    return locations
        .where((element) => element.locationId == location.locationId)
        .first
        .isAcceptingOrders;
  }

  locationName(WidgetRef ref) {
    final location = ref.watch(selectedLocationProvider);
    final locations = ref.watch(allLocationsProvider);
    return locations
        .where((element) => element.locationId == location.locationId)
        .first
        .name;
  }

  Future<Position?> handleLocationPermissionsWeb() async {
    Position? position;
    await PermissionHandler().locationPermission(
      onGranted: () async {
        // Get current position
        position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);
      },
      onDeclined: () async {
        // Handle declined permission
        position = null;
      },
    );
    return position;
  }

  Future<void> chooseLocation(BuildContext context, WidgetRef ref) async {
    // Request location permission on iOS or Android
    await PermissionHandler().locationPermission(
      onGranted: () async {
        // Get current position
        final position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);
        ref.read(currentLocationLatLongProvider.notifier).state =
            LatLng(position.latitude, position.longitude);
      },
      onDeclined: () async {
        // Show dialog if permission is declined
        ref.read(currentLocationLatLongProvider.notifier).state =
            AppConstants.renoNV;
      },
    );
    Future.delayed(const Duration(milliseconds: 100), () {
      ModalBottomSheet().fullScreen(
        context: context,
        builder: (context) => const LocationPageMobile(),
      );
    });
  }

  emptyLocationModel() {
    return const LocationModel(
      uid: '',
      name: '',
      status: '',
      locationId: '',
      squareLocationId: '',
      phone: '',
      address: {},
      hours: [],
      timezone: '',
      currency: '',
      geohash: '',
      latitude: 0,
      longitude: 0,
      isActive: false,
      isAcceptingOrders: false,
      salesTaxRate: 0,
      unavailableProducts: [],
      blackoutDates: [],
    );
  }

  void calculateListScroll(
    WidgetRef ref,
    int index,
    double tileSize,
  ) {
    final double screenWidth = AppConstants.screenWidth;
    final double targetPosition =
        index * tileSize; // tileSize should be the width of your tile
    final double additionalOffset = screenWidth * -0.005;
    final double offset = targetPosition - additionalOffset;

    // Scroll to the calculated offset.
    // Make sure to clamp the value between 0 and the max scroll extent
    final ScrollController listController =
        ref.read(locationListControllerProvider);
    final double clampedOffset =
        offset.clamp(0, listController.position.maxScrollExtent);

    listController.animateTo(
      clampedOffset,
      duration: const Duration(milliseconds: 500),
      curve: Curves.decelerate,
    );
  }

  setLocationDataFromMap(WidgetRef ref, LocationModel location) {
    if (location.status == AppConstants.comingSoon) {
      return null;
    } else {
      _setSelectedLocation(ref, location);
      _setLatAndLongOfLocation(ref, location);
      _setOpenAndCloseTime(ref, location);
    }
  }

  _setLatAndLongOfLocation(WidgetRef ref, location) {
    ref.read(currentLocationLatLongProvider.notifier).state =
        LatLng(location.latitude, location.longitude);
  }

  _setOpenAndCloseTime(WidgetRef ref, location) {
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

  _setSelectedLocation(WidgetRef ref, location) {
    ref.read(selectedLocationProvider.notifier).state = location;
  }

  getCurrentBounds(WidgetRef ref) async {
    final mapController = ref.read(googleMapControllerProvider);
    var mapBounds = LatLngBounds(
        southwest: const LatLng(0.0, 0.0), northeast: const LatLng(0.0, 0.0));
    if (mapController == null) {
      return null;
    } else {
      await mapController.getVisibleRegion();
      mapBounds = await mapController.getVisibleRegion();
      ref.read(currentMapBoundsProvider.notifier).state = mapBounds;
      double distance =
          LocationHelper().getMapBoundsDistanceInMeters(mapBounds);
      if (distance < AppConstants.oneHundredMilesInMeters) {
        var locationsWithinBounds =
            await LocationServices().getLocationsWithinMapBounds(mapBounds);
        ref.read(locationsWithinMapBoundsProvider.notifier).state =
            locationsWithinBounds;
      } else {
        ref.invalidate(locationsWithinMapBoundsProvider);
      }
    }
  }

  double getMapBoundsDistanceInMeters(LatLngBounds mapBounds) {
    return Geolocator.distanceBetween(
      mapBounds.northeast.latitude,
      mapBounds.northeast.longitude,
      mapBounds.southwest.latitude,
      mapBounds.southwest.longitude,
    );
  }
}
