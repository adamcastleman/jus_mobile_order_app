import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/Validators/checkout_validators.dart';
import 'package:jus_mobile_order_app/Helpers/Validators/order_validators.dart';
import 'package:jus_mobile_order_app/Helpers/divider.dart';
import 'package:jus_mobile_order_app/Helpers/modal_bottom_sheets.dart';
import 'package:jus_mobile_order_app/Helpers/orders.dart';
import 'package:jus_mobile_order_app/Helpers/pricing.dart';
import 'package:jus_mobile_order_app/Helpers/spacing_widgets.dart';
import 'package:jus_mobile_order_app/Models/user_model.dart';
import 'package:jus_mobile_order_app/Payments/apple_pay_selected_tile.dart';
import 'package:jus_mobile_order_app/Payments/no_charge_payment_tile.dart';
import 'package:jus_mobile_order_app/Payments/payment_method_selector.dart';
import 'package:jus_mobile_order_app/Payments/tip_sheet.dart';
import 'package:jus_mobile_order_app/Providers/auth_providers.dart';
import 'package:jus_mobile_order_app/Providers/discounts_provider.dart';
import 'package:jus_mobile_order_app/Providers/offers_providers.dart';
import 'package:jus_mobile_order_app/Providers/order_providers.dart';
import 'package:jus_mobile_order_app/Providers/payments_providers.dart';
import 'package:jus_mobile_order_app/Providers/points_providers.dart';
import 'package:jus_mobile_order_app/Providers/stream_providers.dart';
import 'package:jus_mobile_order_app/Providers/theme_providers.dart';
import 'package:jus_mobile_order_app/Sheets/invalid_sheet_single_pop.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/close_button.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/elevated_button_large.dart';
import 'package:jus_mobile_order_app/Widgets/General/category_display_widget.dart';
import 'package:jus_mobile_order_app/Widgets/General/text_fields.dart';
import 'package:jus_mobile_order_app/Widgets/Lists/display_order_list.dart';
import 'package:jus_mobile_order_app/Widgets/Lists/offers_list_checkout.dart';
import 'package:jus_mobile_order_app/Widgets/Lists/rewards_list.dart';
import 'package:jus_mobile_order_app/Widgets/Tiles/order_pickup_date_tile.dart';
import 'package:jus_mobile_order_app/Widgets/Tiles/order_pickup_time_tile.dart';
import 'package:jus_mobile_order_app/Widgets/Tiles/selected_location_tile.dart';

import '../Payments/total_price.dart';

class CheckoutPage extends HookConsumerWidget {
  const CheckoutPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider).value!;
    final controller = useScrollController();
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
                      HapticFeedback.lightImpact();
                      ref.read(checkOutPageProvider.notifier).state = false;
                      ref.invalidate(rewardQuantityProvider);
                      ref.invalidate(totalPointsProvider);
                      ref.invalidate(pointsInUseProvider);
                      ref.invalidate(discountTotalProvider);
                      ref.invalidate(selectedPickupDateProvider);
                      ref.invalidate(scheduleAllItemsProvider);
                      ref.invalidate(selectedTipIndexProvider);
                      ref.invalidate(selectedTipPercentageProvider);
                      ref.invalidate(pointsMultiplierProvider);
                      ref.invalidate(applePaySelectedProvider);
                      Navigator.pop(context);
                    },
                  ),
                ]),
            body: ListView(
              shrinkWrap: true,
              controller: controller,
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
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
                _determinePaymentMethodTile(ref, user),
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
                      _validateCheckoutData(context, ref, user, controller);
                    },
                  ),
                ),
                Spacing().vertical(40),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _validateCheckoutData(BuildContext context, WidgetRef ref, UserModel user,
      ScrollController controller) {
    String? validationResult =
        OrderValidators(ref: ref).checkPickupTime(context);

    if (validationResult != null) {
      ModalBottomSheet().partScreen(
        context: context,
        builder: (context) => InvalidSheetSinglePop(error: validationResult),
      );
    } else {
      _validateGuestFormAndContinue(context, ref, user, controller);
    }
  }

  _determinePaymentMethodTile(WidgetRef ref, UserModel user) {
    final firstNameError = ref.watch(firstNameErrorProvider);
    final lastNameError = ref.watch(lastNameErrorProvider);
    final emailError = ref.watch(emailErrorProvider);
    final phoneError = ref.watch(phoneErrorProvider);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Spacing().vertical(30),
        const CategoryWidget(text: 'Payment'),
        user.uid == null
            ? Column(
                children: [
                  Spacing().vertical(10),
                  user.uid == null
                      ? JusTextField(ref: ref).firstName(user: user)
                      : const SizedBox(),
                  JusTextField(ref: ref).error(firstNameError),
                  Spacing().vertical(10),
                  user.uid == null
                      ? JusTextField(ref: ref).lastName(user: user)
                      : const SizedBox(),
                  JusTextField(ref: ref).error(lastNameError),
                  Spacing().vertical(10),
                  user.uid == null
                      ? JusTextField(ref: ref).phone(user: user)
                      : const SizedBox(),
                  JusTextField(ref: ref).error(phoneError),
                  Spacing().vertical(10),
                  user.uid == null
                      ? JusTextField(ref: ref).email(user: user)
                      : const SizedBox(),
                  JusTextField(ref: ref).error(emailError),
                  Spacing().vertical(10),
                  JusDivider().thin(),
                ],
              )
            : const SizedBox(),
        _getPaymentTile(ref),
        JusDivider().thin(),
      ],
    );
  }

  Widget _getPaymentTile(WidgetRef ref) {
    final applePaySelected = ref.watch(applePaySelectedProvider);
    if (Pricing(ref: ref).isZeroCharge()) {
      return const NoChargePaymentTile();
    } else if ((Platform.isIOS || Platform.isMacOS) && applePaySelected) {
      return const ApplePaySelectedTile();
    } else {
      return Column(
        children: [
          const PaymentMethodSelector(),
          JusDivider().thin(),
          (Platform.isIOS || Platform.isMacOS)
              ? const ApplePaySelectedTile()
              : const SizedBox(),
        ],
      );
    }
  }

  void _validateGuestFormAndContinue(BuildContext context, WidgetRef ref,
      UserModel user, ScrollController controller) {
    if (user.uid == null) {
      CheckoutValidators(ref: ref).validateForm();
      if (!ref.read(formValidatedProvider)) {
        _scrollToTop(controller);
      } else {
        _showTipSheet(context, ref);
      }
    } else {
      _showTipSheet(context, ref);
    }
  }

  void _scrollToTop(ScrollController controller) {
    controller.animateTo(
      0.0,
      duration: const Duration(milliseconds: 200),
      curve: Curves.linear,
    );
  }

  void _showTipSheet(BuildContext context, WidgetRef ref) {
    ModalBottomSheet().partScreen(
      isScrollControlled: true,
      enableDrag: false,
      isDismissible: true,
      context: context,
      builder: (context) => const TipSheet(),
    );
  }
}
