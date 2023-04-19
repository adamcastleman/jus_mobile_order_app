import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/modal_bottom_sheets.dart';
import 'package:jus_mobile_order_app/Helpers/permission_handler.dart';
import 'package:jus_mobile_order_app/Models/location_model.dart';
import 'package:jus_mobile_order_app/Models/product_model.dart';
import 'package:jus_mobile_order_app/Providers/stream_providers.dart';

import '../Providers/location_providers.dart';
import '../Views/choose_location_page.dart';

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

  productInStock(WidgetRef ref, ProductModel product) {
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

  name(WidgetRef ref) {
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

  chooseLocation(BuildContext context, WidgetRef ref) async {
    await HandlePermissions(context, ref).locationPermission();
    if (context.mounted) {
      ModalTopSheet().fullScreen(
        context: context,
        child: const ChooseLocationPage(),
      );
    }
  }

  emptyLocationModel() {
    return const LocationModel(
      uid: '',
      name: '',
      locationID: 0,
      phone: 0,
      address: {},
      hours: [],
      timezone: '',
      currency: '',
      latitude: 0,
      longitude: 0,
      isActive: false,
      isAcceptingOrders: false,
      salesTaxRate: 0,
      acceptingOrders: false,
      unavailableProducts: [],
      comingSoon: false,
      blackoutDates: [],
    );
  }
}
