import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Providers/product_providers.dart';
import 'package:jus_mobile_order_app/Views/empty_cart_page.dart';
import 'package:jus_mobile_order_app/Widgets/General/total_price.dart';
import 'package:jus_mobile_order_app/Widgets/Helpers/divider.dart';
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
                style: Theme.of(context).textTheme.headline5,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 22.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Location',
                      style: TextStyle(fontSize: 16),
                    ),
                    JusDivider().thick(),
                    const Padding(
                      padding: EdgeInsets.only(bottom: 30.0),
                      child: SelectedLocationTile(),
                    ),
                    const Text(
                      'Your order',
                      style: TextStyle(fontSize: 16),
                    ),
                    JusDivider().thick(),
                    const DisplayOrderList(),
                    JusDivider().thick(),
                    const TotalPrice(),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }
  }
}
