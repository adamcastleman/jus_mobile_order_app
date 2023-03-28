import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/locations.dart';
import 'package:jus_mobile_order_app/Helpers/time.dart';
import 'package:jus_mobile_order_app/Models/location_model.dart';
import 'package:jus_mobile_order_app/Models/product_model.dart';
import 'package:jus_mobile_order_app/Providers/auth_providers.dart';
import 'package:jus_mobile_order_app/Providers/location_providers.dart';
import 'package:jus_mobile_order_app/Providers/order_providers.dart';
import 'package:jus_mobile_order_app/Providers/product_providers.dart';
import 'package:jus_mobile_order_app/Providers/stream_providers.dart';

class FormValidator {
  email(WidgetRef ref) {
    ref.read(emailErrorProvider.notifier).state =
        'This email address is badly formatted or otherwise invalid.';
    ref.read(loadingProvider.notifier).state = false;
  }

  passwordRegister(WidgetRef ref) {
    ref.read(passwordErrorProvider.notifier).state =
        'This password is not valid. Please attempt a new one.';
    ref.read(loadingProvider.notifier).state = false;
  }

  confirmPassword(WidgetRef ref) {
    ref.read(confirmPasswordErrorProvider.notifier).state =
        'Passwords do not match';
    ref.read(loadingProvider.notifier).state = false;
  }

  firstName(WidgetRef ref) {
    ref.read(firstNameErrorProvider.notifier).state =
        'Please provide your first name';
    ref.read(loadingProvider.notifier).state = false;
  }

  lastName(WidgetRef ref) {
    ref.read(lastNameErrorProvider.notifier).state =
        'Please provide your last name';
    ref.read(loadingProvider.notifier).state = false;
  }

  phone(WidgetRef ref) {
    ref.read(phoneErrorProvider.notifier).state =
        'Phone number must be exactly 10 digits';
    ref.read(loadingProvider.notifier).state = false;
  }
}

class OrderValidators {
  final WidgetRef ref;

  OrderValidators({required this.ref});

  String checkValidity(BuildContext context) {
    HapticFeedback.heavyImpact();

    String? errorMessage;

    errorMessage = _checkScheduledOrder();
    if (errorMessage != null) return errorMessage;

    errorMessage = _checkNotAcceptingOrders(context);
    if (errorMessage != null) return errorMessage;

    errorMessage = _checkPickupTime();
    if (errorMessage != null) return errorMessage;

    errorMessage = _checkUnavailableItems();
    if (errorMessage != null) return errorMessage;

    return '';
  }

  String? _checkScheduledOrder() {
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

  String? _checkNotAcceptingOrders(BuildContext context) {
    bool isScheduledOrder = ref.watch(scheduleAllItemsProvider);
    bool notAcceptingOrders = !Time().acceptingOrders(context, ref) ||
        !LocationHelper().acceptingOrders(ref);
    bool notValidScheduleDate = !_isScheduleDateValid();

    if (!isScheduledOrder && notAcceptingOrders && notValidScheduleDate) {
      return 'Please schedule your pickup date for ${LocationHelper().selectedLocation(ref).name}, which is not accepting pickup orders right now.';
    }

    return null;
  }

  String? _checkPickupTime() {
    bool isScheduledOrder = ref.watch(scheduleAllItemsProvider);
    DateTime? pickupTime = ref.watch(selectedPickupTimeProvider);
    bool notValidSelectedTime = !_isSelectedTimeValid();

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
      return '$unavailableItems at ${LocationHelper().selectedLocation(ref).name} right now. Please remove this item from your cart before continuing.';
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
