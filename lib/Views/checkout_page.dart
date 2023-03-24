import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/divider.dart';
import 'package:jus_mobile_order_app/Helpers/modal_bottom_sheets.dart';
import 'package:jus_mobile_order_app/Helpers/orders.dart';
import 'package:jus_mobile_order_app/Helpers/pricing.dart';
import 'package:jus_mobile_order_app/Helpers/spacing_widgets.dart';
import 'package:jus_mobile_order_app/Providers/ProviderWidgets/user_provider_widget.dart';
import 'package:jus_mobile_order_app/Providers/discounts_provider.dart';
import 'package:jus_mobile_order_app/Providers/offers_providers.dart';
import 'package:jus_mobile_order_app/Providers/order_providers.dart';
import 'package:jus_mobile_order_app/Providers/points_providers.dart';
import 'package:jus_mobile_order_app/Providers/theme_providers.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/close_button.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/elevated_button_large.dart';
import 'package:jus_mobile_order_app/Widgets/General/category_display_widget.dart';
import 'package:jus_mobile_order_app/Widgets/Lists/display_order_list.dart';
import 'package:jus_mobile_order_app/Widgets/Lists/offers_list_checkout.dart';
import 'package:jus_mobile_order_app/Widgets/Lists/rewards_list.dart';
import 'package:jus_mobile_order_app/Widgets/Payments/no_charge_payment_tile.dart';
import 'package:jus_mobile_order_app/Widgets/Payments/payment_method_selector.dart';
import 'package:jus_mobile_order_app/Widgets/Payments/tip_sheet.dart';
import 'package:jus_mobile_order_app/Widgets/Tiles/order_pickup_date_tile.dart';
import 'package:jus_mobile_order_app/Widgets/Tiles/order_pickup_time_tile.dart';
import 'package:jus_mobile_order_app/Widgets/Tiles/selected_location_tile.dart';

import '../Widgets/General/total_price.dart';

class CheckoutPage extends ConsumerWidget {
  const CheckoutPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return UserProviderWidget(
      builder: (user) => Container(
        color: ref.watch(backgroundColorProvider),
        padding:
            EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.05),
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
                      const CategoryWidget(text: 'Order Details'),
                      const SelectedLocationTile(),
                      OrderHelpers(ref: ref).scheduledItems().isNotEmpty
                          ? const OrderPickupDateTile()
                          : const SizedBox(),
                      OrderHelpers(ref: ref).nonScheduledItems().isNotEmpty &&
                              ref.watch(scheduleAllItemsProvider) == false
                          ? const OrderPickupTimeTile()
                          : const SizedBox(),
                      _determinePaymentMethodTile(ref),
                      Spacing().vertical(20),
                      const CategoryWidget(
                        text: 'Your Order',
                      ),
                      const DisplayOrderList(),
                      const AvailableOffersList(),
                      const CategoryWidget(
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
      ),
    );
  }

  _determinePaymentMethodTile(WidgetRef ref) {
    return Column(
      children: [
        Spacing().vertical(30),
        const CategoryWidget(text: 'Payment Method'),
        _getPaymentTile(ref),
        JusDivider().thin(),
      ],
    );
  }

  Widget _getPaymentTile(WidgetRef ref) {
    return Pricing(ref: ref).isZeroCharge()
        ? const NoChargePaymentTile()
        : const PaymentMethodSelector();
  }
}
