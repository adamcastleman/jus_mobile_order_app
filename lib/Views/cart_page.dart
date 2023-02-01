import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Providers/order_providers.dart';
import 'package:jus_mobile_order_app/Providers/product_providers.dart';
import 'package:jus_mobile_order_app/Views/checkout_page.dart';
import 'package:jus_mobile_order_app/Views/empty_cart_page.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/elevated_button_large.dart';
import 'package:jus_mobile_order_app/Widgets/General/cart_category_descriptor.dart';
import 'package:jus_mobile_order_app/Widgets/General/total_price.dart';
import 'package:jus_mobile_order_app/Widgets/Helpers/divider.dart';
import 'package:jus_mobile_order_app/Widgets/Helpers/modal_bottom_sheets.dart';
import 'package:jus_mobile_order_app/Widgets/Helpers/spacing_widgets.dart';
import 'package:jus_mobile_order_app/Widgets/Lists/display_order_list.dart';
import 'package:jus_mobile_order_app/Widgets/Tiles/selected_location_tile.dart';

class CartPage extends ConsumerWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentOrder = ref.watch(currentOrderItemsProvider);

    if (currentOrder.isEmpty) {
      return const EmptyCartPage();
    } else {
      return SafeArea(
        child: Scaffold(
          body: ListView(
            padding: const EdgeInsets.all(22.0),
            children: [
              Text(
                'Review order',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 22.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CartCategory(
                      text: 'Location',
                    ),
                    const Padding(
                      padding: EdgeInsets.only(bottom: 30.0),
                      child: SelectedLocationTile(),
                    ),
                    const CartCategory(
                      text: 'Your order',
                    ),
                    const DisplayOrderList(),
                    JusDivider().thick(),
                    const TotalPrice(),
                    Spacing().vertical(40),
                    LargeElevatedButton(
                      buttonText: 'Check out',
                      onPressed: () {
                        determineScheduledAndNowItemsInCartProvider(ref);

                        // determineEarliestPickupTime(ref);
                        ModalBottomSheet().partScreen(
                          context: context,
                          enableDrag: false,
                          isDismissible: false,
                          isScrollControlled: true,
                          builder: (context) => SizedBox(
                            height: MediaQuery.of(context).size.height * 0.92,
                            child: const CheckoutPage(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }
  }

  void determineScheduledAndNowItemsInCartProvider(WidgetRef ref) {
    final currentOrder = ref.watch(currentOrderItemsProvider);
    final scheduledItems =
        currentOrder.where((element) => element['isScheduled']);
    final nowItems = currentOrder.where((element) => !element['isScheduled']);

    ref.read(scheduledAndNowItemsInCartProvider.notifier).state =
        scheduledItems.isNotEmpty && nowItems.isNotEmpty;
  }

  determineEarliestPickupTime(WidgetRef ref) {
    // ref.read(earliestPickupTimeProvider.notifier).state =
    //     DateTime.now().earliestTime;
  }
}
