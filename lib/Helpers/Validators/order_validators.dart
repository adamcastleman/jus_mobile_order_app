import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/locations.dart';
import 'package:jus_mobile_order_app/Helpers/time.dart';
import 'package:jus_mobile_order_app/Models/location_model.dart';
import 'package:jus_mobile_order_app/Models/product_model.dart';
import 'package:jus_mobile_order_app/Providers/location_providers.dart';
import 'package:jus_mobile_order_app/Providers/order_providers.dart';
import 'package:jus_mobile_order_app/Providers/product_providers.dart';
import 'package:jus_mobile_order_app/Providers/stream_providers.dart';

class OrderValidators {
  final WidgetRef ref;

  OrderValidators({required this.ref});

  String checkValidity(BuildContext context) {
    String? errorMessage;

    errorMessage = checkScheduledOrder();
    if (errorMessage != null) return errorMessage;

    errorMessage = checkNotAcceptingOrders(context);
    if (errorMessage != null) return errorMessage;

    errorMessage = checkPickupTime(context);
    if (errorMessage != null) return errorMessage;

    errorMessage = _checkUnavailableItems();
    if (errorMessage != null) return errorMessage;

    return '';
  }

  String? checkScheduledOrder() {
    final currentOrder = ref.watch(currentOrderItemsProvider);

    bool isScheduledOrder =
        currentOrder.every((element) => element['isScheduled'] == true) ||
            ref.watch(scheduleAllItemsProvider);
    bool hasScheduledAndForNowItem =
        ref.watch(scheduledAndNowItemsInCartProvider);
    DateTime? pickupDate = ref.watch(selectedPickupDateProvider);

    if ((isScheduledOrder || hasScheduledAndForNowItem) && pickupDate == null) {
      return 'Your cart contains items that must be scheduled in advance. Please select a pickup date.';
    }

    return null;
  }

  String? checkNotAcceptingOrders(BuildContext context) {
    bool isScheduledOrder = ref.watch(scheduleAllItemsProvider);
    bool notAcceptingOrders = !Time().acceptingOrders(context, ref) ||
        !LocationHelper().acceptingOrders(ref);
    bool notValidScheduleDate = !_isScheduleDateValid();

    if (!isScheduledOrder && notAcceptingOrders && notValidScheduleDate) {
      return 'Please schedule your pickup date for ${LocationHelper().selectedLocation(ref).locationName}, which is not accepting pickup orders right now.';
    }

    return null;
  }

  String? checkPickupTime(BuildContext context) {
    final currentOrder = ref.watch(currentOrderItemsProvider);
    bool isScheduledOrder =
        currentOrder.every((element) => element['isScheduled'] == true) ||
            ref.watch(scheduleAllItemsProvider);
    DateTime? pickupTime = ref.watch(selectedPickupTimeProvider);
    bool notValidSelectedTime = !_isSelectedTimeValid();
    bool acceptingOrders = LocationHelper().acceptingOrders(ref) &&
        Time().acceptingOrders(context, ref);

    if (!isScheduledOrder && !acceptingOrders) {
      return 'This location is not accepting pickup orders right now';
    }

    if (!isScheduledOrder && pickupTime == null) {
      return 'Please select a pickup time for this order';
    }

    if (!isScheduledOrder && notValidSelectedTime) {
      return 'This pickup time is no longer valid.';
    }

    return null;
  }

  String? _checkUnavailableItems() {
    var unavailableItems = getUnavailableItemsMessage();

    if (unavailableItems.isNotEmpty) {
      return '$unavailableItems at ${LocationHelper().selectedLocation(ref).locationName} right now. Please remove this item from your cart before continuing.';
    }

    return null;
  }

  bool _isScheduleDateValid() {
    final currentOrder = ref.watch(currentOrderItemsProvider);
    final scheduledDate = ref.watch(selectedPickupDateProvider);
    final deadline = ref.watch(originalMinimumDateProvider);

    return !currentOrder.any((element) => element['isScheduled'] == true) ||
        (scheduledDate != null &&
            (scheduledDate == deadline || scheduledDate.isAfter(deadline!)));
  }

  bool _isSelectedTimeValid() {
    final selectedTime = ref.watch(selectedPickupTimeProvider);
    final currentTime = Time().now(ref);
    final validTime = currentTime.add(const Duration(minutes: 5));

    return selectedTime != null && selectedTime.isAfter(validTime);
  }

  String getUnavailableItemsMessage() {
    final selectedLocation = ref.watch(selectedLocationProvider);
    final products = ref.watch(productsProvider);
    final locations = ref.watch(locationsProvider);

    return locations.when(
      error: (e, _) => '',
      loading: () => '',
      data: (location) => products.when(
        error: (e, _) => '',
        loading: () => '',
        data: (product) {
          final unavailableProductIDs =
              _getUnavailableProductIDs(location, selectedLocation);
          final unavailableItems =
              _getUnavailableItemsInOrder(product, unavailableProductIDs);
          return _formatUnavailableItemsMessage(unavailableItems);
        },
      ),
    );
  }

  List _getUnavailableProductIDs(
      List<LocationModel> locations, LocationModel selectedLocation) {
    return locations
        .firstWhere(
            (element) => element.locationID == selectedLocation.locationID)
        .unavailableProducts;
  }

  List<String> _getUnavailableItemsInOrder(
      List<ProductModel> products, List unavailableProductIDs) {
    final currentOrder = ref.watch(currentOrderItemsProvider);
    return currentOrder
        .where((item) => unavailableProductIDs.contains(item['productID']))
        .map((item) =>
            products.firstWhere((p) => p.productID == item['productID']))
        .map((product) => product.name)
        .toList();
  }

  _formatUnavailableItemsMessage(List<String> unavailableItems) {
    if (unavailableItems.isEmpty) {
      return '';
    } else if (unavailableItems.length == 1) {
      return '${unavailableItems.first} is not available';
    } else if (unavailableItems.length == 2) {
      return '${unavailableItems.first} and ${unavailableItems.last} are not available';
    } else {
      final lastItem = unavailableItems.removeLast();
      final items = unavailableItems.join(', ');
      return '$items, and $lastItem are not available';
    }
  }
}
