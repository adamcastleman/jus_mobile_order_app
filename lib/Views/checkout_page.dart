import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Providers/order_providers.dart';
import 'package:jus_mobile_order_app/Providers/product_providers.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/close_button.dart';
import 'package:jus_mobile_order_app/Widgets/General/cart_category_descriptor.dart';
import 'package:jus_mobile_order_app/Widgets/Helpers/divider.dart';
import 'package:jus_mobile_order_app/Widgets/Helpers/spacing_widgets.dart';
import 'package:jus_mobile_order_app/Widgets/Tiles/order_pickup_date_tile.dart';
import 'package:jus_mobile_order_app/Widgets/Tiles/order_pickup_time_tile.dart';
import 'package:jus_mobile_order_app/Widgets/Tiles/selected_location_tile.dart';

class CheckoutPage extends ConsumerWidget {
  const CheckoutPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentOrder = ref.watch(currentOrderItemsProvider);
    final scheduledItems = currentOrder
        .where((element) => element['isScheduled'] == true)
        .toList();
    final nonScheduledItems = currentOrder
        .where((element) => element['isScheduled'] != true)
        .toList();
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const JusCloseButton(
                  removePadding: true,
                ),
                Spacing().horizontal(12),
                Text(
                  'Finish your order',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ],
            ),
            Spacing().vertical(30),
            const CartCategory(text: 'Order details'),
            const SelectedLocationTile(),
            scheduledItems.isNotEmpty
                ? const OrderPickupDateTile()
                : const SizedBox(),
            JusDivider().thin(),
            nonScheduledItems.isNotEmpty &&
                    ref.watch(scheduleAllItemsProvider) == false
                ? const OrderPickupTimeTile()
                : const SizedBox(),
          ],
        ),
      ),
    );
  }
}
