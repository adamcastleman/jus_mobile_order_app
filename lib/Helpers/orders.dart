import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/Validators/order_validators.dart';
import 'package:jus_mobile_order_app/Helpers/modal_bottom_sheets.dart';
import 'package:jus_mobile_order_app/Helpers/time.dart';
import 'package:jus_mobile_order_app/Models/product_model.dart';
import 'package:jus_mobile_order_app/Providers/order_providers.dart';
import 'package:jus_mobile_order_app/Sheets/invalid_order_sheet.dart';

import '../Providers/product_providers.dart';

class OrderHelpers {
  final WidgetRef ref;
  OrderHelpers({required this.ref});

  List<Map<String, dynamic>> scheduledItems() {
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

  List<Map<String, dynamic>> nonScheduledItems() {
    final currentOrder = ref.watch(currentOrderItemsProvider);
    final allItemsScheduled = ref.watch(scheduleAllItemsProvider);

    if (allItemsScheduled) {
      return [];
    }

    return currentOrder.where((element) => !element['isScheduled']).toList();
  }

  setScheduledLimitProviders(ProductQuantityModel quantityLimit) {
    ref.read(scheduledQuantityDescriptorProvider.notifier).state =
        quantityLimit.scheduledProductDescriptor;
    ref.read(scheduledProductHoursNoticeProvider.notifier).state =
        quantityLimit.hoursNotice;
  }

  List<Map<String, dynamic>> listOfScheduledItems({
    required List<dynamic> scheduledItems,
    required List<dynamic> products,
  }) {
    Map<String, dynamic> toScheduledItemMap(dynamic item) {
      final product =
          products.firstWhere((p) => p.productID == item['productID']);
      return {
        'name': product.name,
        'productUID': product.uid,
        'scheduledQuantity': item['scheduledQuantity'],
        'scheduledProductDescriptor': item['scheduledProductDescriptor'],
        'itemQuantity': item['itemQuantity'],
      };
    }

    return scheduledItems
        .map<Map<String, dynamic>>(toScheduledItemMap)
        .toList();
  }

  void setOrderingDateAndTimeProviders(List product) {
    final hasScheduledItems = scheduledItems().isNotEmpty;
    final hasNonScheduledItems = nonScheduledItems().isNotEmpty;

    ref.read(scheduledAndNowItemsInCartProvider.notifier).state =
        hasScheduledItems && hasNonScheduledItems;

    setMinimumPickupTime();
  }

  void setMinimumScheduleDate() {
    final hoursNotice = ref.watch(scheduledProductHoursNoticeProvider);
    final selectedTime = ref.read(selectedPickupDateProvider);

    final now = Time().now(ref);
    final deadline = _getDeadline(now, hoursNotice);

    ref
        .read(selectedPickupDateProvider.notifier)
        .selected(selectedTime ?? deadline);
    ref.read(originalMinimumDateProvider.notifier).state = deadline;
  }

  DateTime _getDeadline(DateTime now, int hoursNotice) {
    return DateTime(now.year, now.month, now.day, 0, 0, 0)
        .add(Duration(hours: hoursNotice));
  }

  DateTime setMinimumPickupTime() {
    final nowRounded = Time().nowRounded(ref);
    final openTime = Time().openTime(ref);

    DateTime minimumTime;
    if (nowRounded.isBefore(openTime)) {
      minimumTime = DateTime(nowRounded.year, nowRounded.month, nowRounded.day,
          openTime.hour, openTime.minute);
    } else {
      minimumTime = nowRounded;
    }

    ref.read(originalMinimumTimeProvider.notifier).state = minimumTime;
    ref.read(selectedPickupTimeProvider.notifier).state = minimumTime;

    return minimumTime;
  }

  validateOrder(BuildContext context) {
    final errorMessage = OrderValidators(ref: ref).checkValidity(context);

    if (errorMessage.isNotEmpty) {
      return errorMessage;
    }
  }

  void showInvalidOrderModal(BuildContext context, String errorMessage) {
    ModalBottomSheet().partScreen(
      context: context,
      builder: (context) => InvalidOrderSheet(error: errorMessage),
    );
  }
}
