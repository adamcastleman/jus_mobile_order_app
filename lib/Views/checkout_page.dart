import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/divider.dart';
import 'package:jus_mobile_order_app/Helpers/modal_bottom_sheets.dart';
import 'package:jus_mobile_order_app/Helpers/orders.dart';
import 'package:jus_mobile_order_app/Helpers/spacing_widgets.dart';
import 'package:jus_mobile_order_app/Providers/discounts_provider.dart';
import 'package:jus_mobile_order_app/Providers/offers_providers.dart';
import 'package:jus_mobile_order_app/Providers/order_providers.dart';
import 'package:jus_mobile_order_app/Providers/points_providers.dart';
import 'package:jus_mobile_order_app/Providers/theme_providers.dart';
import 'package:jus_mobile_order_app/Sheets/tip_sheet.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/close_button.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/elevated_button_large.dart';
import 'package:jus_mobile_order_app/Widgets/General/cart_category_descriptor.dart';
import 'package:jus_mobile_order_app/Widgets/Lists/offers_list_checkout.dart';
import 'package:jus_mobile_order_app/Widgets/Lists/rewards_list.dart';
import 'package:jus_mobile_order_app/Widgets/Tiles/current_payment_tile.dart';
import 'package:jus_mobile_order_app/Widgets/Tiles/order_pickup_date_tile.dart';
import 'package:jus_mobile_order_app/Widgets/Tiles/order_pickup_time_tile.dart';
import 'package:jus_mobile_order_app/Widgets/Tiles/selected_location_tile.dart';

import '../Widgets/General/total_price.dart';
import '../Widgets/Lists/display_order_list.dart';

class CheckoutPage extends HookConsumerWidget {
  const CheckoutPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      color: ref.watch(backgroundColorProvider),
      padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.05),
      child: Stack(
        children: [
          Scaffold(
            backgroundColor: ref.watch(backgroundColorProvider),
            appBar: AppBar(
                automaticallyImplyLeading: false,
                title: Text('Finish your order',
                    style: Theme.of(context).textTheme.headlineSmall),
                // centerTitle: false,
                actions: [
                  JusCloseButton(
                    onPressed: () {
                      ref.invalidate(checkOutPageProvider);
                      ref.invalidate(rewardQuantityProvider);
                      ref.invalidate(totalPointsProvider);
                      ref.invalidate(pointsInUseProvider);
                      ref.invalidate(discountTotalProvider);
                      ref.invalidate(selectedPickupDateProvider);
                      ref.invalidate(scheduleAllItemsProvider);
                      ref.invalidate(selectedTipIndexProvider);
                      ref.invalidate(selectedTipPercentageProvider);
                      ref.invalidate(pointsMultiplierProvider);
                      Navigator.pop(context);
                    },
                  ),
                ]),
            body: SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Spacing().vertical(30),
                    const CartCategory(text: 'Order Details'),
                    const SelectedLocationTile(),
                    OrderHelpers(ref: ref).scheduledItems().isNotEmpty
                        ? const OrderPickupDateTile()
                        : const SizedBox(),
                    OrderHelpers(ref: ref).nonScheduledItems().isNotEmpty &&
                            ref.watch(scheduleAllItemsProvider) == false
                        ? const OrderPickupTimeTile()
                        : const SizedBox(),
                    Spacing().vertical(30),
                    const CartCategory(text: 'Payment Method'),
                    const CurrentPaymentTile(
                      isScanPage: false,
                    ),
                    JusDivider().thin(),
                    Spacing().vertical(20),
                    const CartCategory(
                      text: 'Your Order',
                    ),
                    const DisplayOrderList(),
                    const AvailableOffersList(),
                    const CartCategory(
                      text: 'Rewards',
                    ),
                    const RewardsList(),
                    JusDivider().thick(),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: TotalPrice(),
                    ),
                    Spacing().vertical(40),
                    Center(
                      child: LargeElevatedButton(
                        buttonText: 'Checkout',
                        onPressed: () {
                          HapticFeedback.mediumImpact();
                          ModalBottomSheet().partScreen(
                            isScrollControlled: true,
                            enableDrag: false,
                            isDismissible: true,
                            context: context,
                            builder: (context) => const TipSheet(),
                          );
                        },
                      ),
                    ),
                    Spacing().vertical(40),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
