import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/divider.dart';
import 'package:jus_mobile_order_app/Helpers/spacing_widgets.dart';
import 'package:jus_mobile_order_app/Models/user_model.dart';
import 'package:jus_mobile_order_app/Providers/ProviderWidgets/products_provider_widget.dart';
import 'package:jus_mobile_order_app/Providers/product_providers.dart';
import 'package:jus_mobile_order_app/Providers/stream_providers.dart';
import 'package:jus_mobile_order_app/Views/empty_bag_page.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/checkout_button.dart';
import 'package:jus_mobile_order_app/Widgets/General/category_display_widget.dart';
import 'package:jus_mobile_order_app/Widgets/General/total_price.dart';
import 'package:jus_mobile_order_app/Widgets/Lists/display_order_list.dart';
import 'package:jus_mobile_order_app/Widgets/Tiles/selected_location_tile.dart';

class ReviewOrderPage extends ConsumerWidget {
  const ReviewOrderPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider).value ?? const UserModel();
    final currentOrder = ref.watch(currentOrderItemsProvider);
    if (currentOrder.isEmpty) {
      return const EmptyBagPage();
    } else {
      return ProductsProviderWidget(
        builder: (products) => SafeArea(
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
                      const CategoryWidget(
                        text: 'Location',
                      ),
                      const Padding(
                        padding: EdgeInsets.only(bottom: 30.0),
                        child: SelectedLocationTile(),
                      ),
                      const CategoryWidget(
                        text: 'Your Order',
                      ),
                      const DisplayOrderList(),
                      JusDivider().thick(),
                      const TotalPrice(),
                      Spacing.vertical(50),
                      CheckoutButton(user: user, products: products),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }
}
