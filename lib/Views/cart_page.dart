import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/divider.dart';
import 'package:jus_mobile_order_app/Helpers/locations.dart';
import 'package:jus_mobile_order_app/Helpers/modal_bottom_sheets.dart';
import 'package:jus_mobile_order_app/Helpers/orders.dart';
import 'package:jus_mobile_order_app/Helpers/spacing_widgets.dart';
import 'package:jus_mobile_order_app/Models/user_model.dart';
import 'package:jus_mobile_order_app/Providers/ProviderWidgets/products_provider_widget.dart';
import 'package:jus_mobile_order_app/Providers/ProviderWidgets/user_provider_widget.dart';
import 'package:jus_mobile_order_app/Providers/order_providers.dart';
import 'package:jus_mobile_order_app/Providers/points_providers.dart';
import 'package:jus_mobile_order_app/Providers/product_providers.dart';
import 'package:jus_mobile_order_app/Views/checkout_page.dart';
import 'package:jus_mobile_order_app/Views/empty_cart_page.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/elevated_button_large.dart';
import 'package:jus_mobile_order_app/Widgets/General/category_display_widget.dart';
import 'package:jus_mobile_order_app/Widgets/General/total_price.dart';
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
      return ProductsProviderWidget(
        builder: (products) => UserProviderWidget(
          builder: (user) => SafeArea(
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
                        Spacing().vertical(50),
                        LargeElevatedButton(
                          buttonText: 'Checkout',
                          onPressed: () {
                            HapticFeedback.mediumImpact();
                            if (LocationHelper().selectedLocation(ref) ==
                                null) {
                              chooseLocation(context, ref);
                            } else {
                              OrderHelpers(ref: ref)
                                  .setOrderingDateAndTimeProviders(products);
                              setCheckoutPageProviderToTrue(ref);
                              setAvailablePointsProvider(ref, user);

                              ModalBottomSheet().fullScreen(
                                context: context,
                                builder: (context) => const CheckoutPage(),
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }
  }

  chooseLocation(BuildContext context, WidgetRef ref) {
    return LocationHelper().chooseLocation(context, ref);
  }

  setCheckoutPageProviderToTrue(WidgetRef ref) {
    ref.read(checkOutPageProvider.notifier).state = true;
  }

  setAvailablePointsProvider(WidgetRef ref, UserModel user) {
    if (user.uid == null) {
      return;
    } else {
      ref.read(totalPointsProvider.notifier).set(user.points!);
    }
  }
}
