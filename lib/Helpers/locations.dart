import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/modal_bottom_sheets.dart';
import 'package:jus_mobile_order_app/Helpers/permission_handler.dart';
import 'package:jus_mobile_order_app/Models/location_model.dart';
import 'package:jus_mobile_order_app/Models/product_model.dart';
import 'package:jus_mobile_order_app/Providers/controller_providers.dart';
import 'package:jus_mobile_order_app/Providers/stream_providers.dart';
import 'package:jus_mobile_order_app/Services/location_services.dart';
import 'package:jus_mobile_order_app/Widgets/Dialogs/open_app_settings_location.dart';
import 'package:jus_mobile_order_app/constants.dart';
import 'package:permission_handler/permission_handler.dart';

import '../Providers/location_providers.dart';
import '../Views/choose_location_page_mobile.dart';

class LocationHelper {
  selectedLocation(WidgetRef ref) {
    final location = ref.watch(selectedLocationProvider);
    final locations = ref.watch(locationsProvider);
    return locations.when(
      data: (data) {
        if (location == null) {
          return null;
        } else {
          return data
              .where((element) => element.locationID == location.locationID)
              .first;
        }
      },
      error: (e, _) => false,
      loading: () => emptyLocationModel(),
    );
  }

  bool isProductInStock(WidgetRef ref, ProductModel product) {
    return LocationHelper().selectedLocation(ref) == null ||
        !LocationHelper()
            .selectedLocation(ref)
            .unavailableProducts
            .contains(product.productID);
  }

  acceptingOrders(WidgetRef ref) {
    final location = ref.watch(selectedLocationProvider);
    final locations = ref.watch(locationsProvider);
    return locations.when(
      data: (data) {
        if (location == null) {
          return true;
        } else {
          return data
              .where((element) => element.locationID == location.locationID)
              .first
              .acceptingOrders;
        }
      },
      error: (e, _) => false,
      loading: () => true,
    );
  }

  locationName(WidgetRef ref) {
    final location = ref.watch(selectedLocationProvider);
    final locations = ref.watch(locationsProvider);
    return locations.when(
      data: (data) {
        if (location == null) {
          return true;
        } else {
          return data
              .where((element) => element.locationID == location.locationID)
              .first
              .name;
        }
      },
      error: (e, _) => false,
      loading: () => emptyLocationModel(),
    );
  }

  Future<void> handleLocationPermissionsWeb(WidgetRef ref) async {
    await PermissionHandler().locationPermission(
      onGranted: () async {
        // Get current position
        final position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);
        // Update state only once
        ref.read(currentLocationLatLongProvider.notifier).state =
            LatLng(position.latitude, position.longitude);
      },
      onDeclined: () {},
    );
  }

  Future<void> chooseLocation(BuildContext context, WidgetRef ref) async {
    // Request location permission on iOS or Android
    final permissionStatus = await PermissionHandler().locationPermission(
      onGranted: () async {
        // Get current position
        final position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);
        ref.read(currentLocationLatLongProvider.notifier).state =
            LatLng(position.latitude, position.longitude);
      },
      onDeclined: () {
        // Show dialog if permission is declined
        showDialog(
          context: context,
          builder: (context) => const LocationPermissionAlertDialog(),
        );
      },
    );

    // Check if permission is granted, limited, or restricted
    if (permissionStatus.isGranted ||
        permissionStatus.isLimited ||
        permissionStatus.isRestricted) {
      // Show the ChooseLocationPageMobile after a short delay
      Future.delayed(const Duration(milliseconds: 100), () {
        ModalTopSheet().fullScreen(
          context: context,
          child: const ChooseLocationPageMobile(),
        );
      });
    }
  }

  emptyLocationModel() {
    return const LocationModel(
      uid: '',
      name: '',
      status: '',
      locationID: 0,
      squareLocationId: '',
      phone: 0,
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
      acceptingOrders: false,
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
