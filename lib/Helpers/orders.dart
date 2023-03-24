import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/locations.dart';
import 'package:jus_mobile_order_app/Helpers/modal_bottom_sheets.dart';
import 'package:jus_mobile_order_app/Helpers/time.dart';
import 'package:jus_mobile_order_app/Models/user_model.dart';
import 'package:jus_mobile_order_app/Providers/location_providers.dart';
import 'package:jus_mobile_order_app/Providers/order_providers.dart';
import 'package:jus_mobile_order_app/Services/payments_services.dart';
import 'package:jus_mobile_order_app/Sheets/invalid_order_sheet.dart';

import '../Providers/product_providers.dart';
import '../Providers/stream_providers.dart';

class OrderHelpers {
  final WidgetRef ref;
  OrderHelpers({required this.ref});

  scheduledItems() {
    final currentOrder = ref.watch(currentOrderItemsProvider);
    final allItemsScheduled = ref.watch(scheduleAllItemsProvider);
    if (allItemsScheduled) {
      return currentOrder;
    } else {
      return currentOrder
          .where((element) => element['isScheduled'] == true)
          .toList();
    }
  }

  nonScheduledItems() {
    final currentOrder = ref.watch(currentOrderItemsProvider);
    final allItemsScheduled = ref.watch(scheduleAllItemsProvider);
    if (allItemsScheduled) {
      return [];
    } else {
      return currentOrder
          .where((element) => element['isScheduled'] != true)
          .toList();
    }
  }

  List<Map<String, dynamic>> listOfScheduledItems({
    required List<dynamic> scheduledItems,
    required List<dynamic> products,
  }) {
    final scheduledItemMaps = <Map<String, dynamic>>[];

    for (final item in scheduledItems) {
      final product = products
          .firstWhere((element) => element.productID == item['productID']);

      final name = product.name;
      final daysQuantity = item['daysQuantity'];
      final itemQuantity = item['itemQuantity'];
      final hoursNotice = product.hoursNotice;

      final scheduledItemMap = {
        'name': name,
        'daysQuantity': daysQuantity,
        'itemQuantity': itemQuantity,
        'hoursNotice': hoursNotice,
      };

      scheduledItemMaps.add(scheduledItemMap);
    }

    return scheduledItemMaps;
  }

  void setOrderingDateAndTimeProviders(List product) {
    ref.read(scheduledAndNowItemsInCartProvider.notifier).state =
        OrderHelpers(ref: ref).scheduledItems().isNotEmpty &&
            OrderHelpers(ref: ref).nonScheduledItems().isNotEmpty;
    setHoursNoticeProvider(product);
    setMinimumPickupTime();
  }

  void setHoursNoticeProvider(List product) {
    var items = listOfScheduledItems(
      scheduledItems: OrderHelpers(ref: ref).scheduledItems(),
      products: product,
    );

    int firstItemHoursNotice =
        items.isNotEmpty ? items.first['hoursNotice'] : 0;

    ref.read(scheduledProductHoursNoticeProvider.notifier).state =
        firstItemHoursNotice;
  }

  void setMinimumScheduleDate() {
    final hoursNotice = ref.watch(scheduledProductHoursNoticeProvider);
    final selectedTime = ref.read(selectedPickupDateProvider);
    DateTime now = Time().now(ref);
    DateTime deadline = DateTime(now.year, now.month, now.day, 0, 0, 0)
        .add(Duration(hours: hoursNotice));

    ref
        .read(selectedPickupDateProvider.notifier)
        .selected(selectedTime ?? deadline);

    ref.read(originalMinimumDateProvider.notifier).state = deadline;
  }

  setMinimumPickupTime() {
    if (Time().nowRounded(ref).isBefore(Time().openTime(ref))) {
      ref.read(originalMinimumTimeProvider.notifier).state =
          Time().openTime(ref);
      ref.read(selectedPickupTimeProvider.notifier).state =
          Time().openTime(ref);
      return Time().openTime(ref);
    } else {
      ref.read(originalMinimumTimeProvider.notifier).state =
          Time().nowRounded(ref);
      ref.read(selectedPickupTimeProvider.notifier).state =
          Time().nowRounded(ref);
      return Time().nowRounded(ref);
    }
  }

  bool isScheduleDateValid() {
    final currentOrder = ref.watch(currentOrderItemsProvider);
    final scheduledDate = ref.watch(selectedPickupDateProvider);
    final deadline = ref.watch(originalMinimumDateProvider);

    if (currentOrder.any((element) => element['isScheduled'] == true)) {
      if (scheduledDate == null) {
        return false;
      }

      return scheduledDate == deadline || scheduledDate.isAfter(deadline!);
    }
    return true;
  }

  bool isSelectedTimeValid() {
    final selectedTime = ref.watch(selectedPickupTimeProvider);
    final currentTime = Time().now(ref);
    final validTime = currentTime.add(const Duration(minutes: 5));

    if (selectedTime == null) {
      return false;
    }
    if (selectedTime.isBefore(validTime)) {
      return false;
    }
    return true;
  }

  String getUnavailableItemsMessage() {
    final locations = ref.watch(locationsProvider);
    final currentOrder = ref.watch(currentOrderItemsProvider);
    final selectedLocation = ref.watch(selectedLocationProvider);
    final products = ref.watch(productsProvider);

    return products.when(
      error: (e, _) => '',
      loading: () => '',
      data: (product) => locations.when(
        error: (e, _) => '',
        loading: () => '',
        data: (location) {
          final unavailableProductIDs = location
              .firstWhere((element) =>
                  element.locationID == selectedLocation.locationID)
              .unavailableProducts;

          final unavailableItems = currentOrder
              .where(
                  (item) => unavailableProductIDs.contains(item['productID']))
              .map((item) =>
                  product.firstWhere((p) => p.productID == item['productID']))
              .map((product) => product.name)
              .toList();

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
        },
      ),
    );
  }

  void validateOrderAndPay(BuildContext context, UserModel user) {
    final errorMessage = OrderHelpers(ref: ref).checkValidity(context);

    if (errorMessage.isNotEmpty) {
      ModalBottomSheet().partScreen(
          context: context,
          builder: (context) => InvalidOrderSheet(error: errorMessage));
      return;
    } else {
      PaymentsServices(ref: ref, context: context)
          .chargeCardAndCreateOrder(user)
          .then(
            (result) =>
                PaymentsServices(ref: ref).handlePaymentResult(context, result),
          );
    }
  }

  String checkValidity(BuildContext context) {
    final currentOrder = ref.watch(currentOrderItemsProvider);

    bool isScheduledOrder =
        currentOrder.every((element) => element['isScheduled'] == true) ||
            ref.watch(scheduleAllItemsProvider);
    bool hasScheduledAndForNowItem =
        ref.watch(scheduledAndNowItemsInCartProvider);
    DateTime? pickupDate = ref.watch(selectedPickupDateProvider);
    DateTime? pickupTime = ref.watch(selectedPickupTimeProvider);
    bool notAcceptingOrders = !Time().acceptingOrders(context, ref) ||
        !LocationHelper().acceptingOrders(ref);
    bool notValidScheduleDate = !isScheduleDateValid();
    bool notValidSelectedTime =
        ref.watch(scheduleAllItemsProvider) != true && !isSelectedTimeValid();
    String unavailableItems = getUnavailableItemsMessage();

    HapticFeedback.heavyImpact();

    if ((isScheduledOrder || hasScheduledAndForNowItem) && pickupDate == null) {
      return 'Your cart contains items that must be scheduled in advance. Please select a pickup date.';
    }

    if (!isScheduledOrder && notAcceptingOrders) {
      return '${LocationHelper().selectedLocation(ref).name} is not accepting pickup orders right now.';
    }

    if (!isScheduledOrder && pickupTime == null) {
      return 'Please select a pickup time for this order';
    }

    if (hasScheduledAndForNowItem &&
        notAcceptingOrders &&
        notValidScheduleDate) {
      return 'Please schedule your pickup date for ${LocationHelper().selectedLocation(ref).name}, which is not accepting pickup orders right now.';
    }

    if (!isScheduledOrder && notValidSelectedTime) {
      return 'This pickup time is no longer valid.';
    }

    if (unavailableItems.isNotEmpty) {
      return '$unavailableItems at ${LocationHelper().selectedLocation(ref).name} right now. Please remove this item from you cart before continuing.';
    }

    return '';
  }
}
