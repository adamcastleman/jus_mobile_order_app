import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/divider.dart';
import 'package:jus_mobile_order_app/Helpers/modal_bottom_sheets.dart';
import 'package:jus_mobile_order_app/Helpers/orders.dart';
import 'package:jus_mobile_order_app/Helpers/pricing.dart';
import 'package:jus_mobile_order_app/Helpers/spacing_widgets.dart';
import 'package:jus_mobile_order_app/Helpers/validators.dart';
import 'package:jus_mobile_order_app/Models/user_model.dart';
import 'package:jus_mobile_order_app/Providers/ProviderWidgets/user_provider_widget.dart';
import 'package:jus_mobile_order_app/Providers/auth_providers.dart';
import 'package:jus_mobile_order_app/Providers/discounts_provider.dart';
import 'package:jus_mobile_order_app/Providers/offers_providers.dart';
import 'package:jus_mobile_order_app/Providers/order_providers.dart';
import 'package:jus_mobile_order_app/Providers/payments_providers.dart';
import 'package:jus_mobile_order_app/Providers/points_providers.dart';
import 'package:jus_mobile_order_app/Providers/theme_providers.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/close_button.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/elevated_button_large.dart';
import 'package:jus_mobile_order_app/Widgets/General/category_display_widget.dart';
import 'package:jus_mobile_order_app/Widgets/General/text_fields.dart';
import 'package:jus_mobile_order_app/Widgets/Lists/display_order_list.dart';
import 'package:jus_mobile_order_app/Widgets/Lists/offers_list_checkout.dart';
import 'package:jus_mobile_order_app/Widgets/Lists/rewards_list.dart';
import 'package:jus_mobile_order_app/Widgets/Payments/choose_payment_type_sheet.dart';
import 'package:jus_mobile_order_app/Widgets/Payments/no_charge_payment_tile.dart';
import 'package:jus_mobile_order_app/Widgets/Payments/payment_method_selector.dart';
import 'package:jus_mobile_order_app/Widgets/Payments/tip_sheet.dart';
import 'package:jus_mobile_order_app/Widgets/Tiles/order_pickup_date_tile.dart';
import 'package:jus_mobile_order_app/Widgets/Tiles/order_pickup_time_tile.dart';
import 'package:jus_mobile_order_app/Widgets/Tiles/selected_location_tile.dart';

import '../Widgets/General/total_price.dart';

class CheckoutPage extends HookConsumerWidget {
  const CheckoutPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = useScrollController();
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
                        HapticFeedback.mediumImpact();
                        _validateGuestFormAndContinue(
                            context, ref, user, controller);
                      },
                    ),
                  ),
                  Spacing().vertical(40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
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
                      ? JusTextField(ref: ref).firstName()
                      : const SizedBox(),
                  JusTextField(ref: ref).error(firstNameError),
                  Spacing().vertical(10),
                  user.uid == null
                      ? JusTextField(ref: ref).lastName()
                      : const SizedBox(),
                  JusTextField(ref: ref).error(lastNameError),
                  Spacing().vertical(10),
                  user.uid == null
                      ? JusTextField(ref: ref).phone()
                      : const SizedBox(),
                  JusTextField(ref: ref).error(phoneError),
                  Spacing().vertical(10),
                  user.uid == null
                      ? JusTextField(ref: ref).email()
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
    return Pricing(ref: ref).isZeroCharge()
        ? const NoChargePaymentTile()
        : const PaymentMethodSelector();
  }

  _validateGuestFormAndContinue(BuildContext context, WidgetRef ref,
      UserModel user, ScrollController controller) {
    final firstName = ref.watch(firstNameProvider);
    final lastName = ref.watch(lastNameProvider);
    final email = ref.watch(emailProvider);
    final phone = ref.watch(phoneProvider);
    if (user.uid == null) {
      _validateForm(
        ref: ref,
        firstName: firstName,
        lastName: lastName,
        email: email,
        phone: phone,
      );
      if (!ref.read(formValidatedProvider)) {
        controller.animateTo(0.0,
            duration: const Duration(milliseconds: 200), curve: Curves.linear);
      }
    }

    if (ref.read(formValidatedProvider)) {
      ModalBottomSheet().partScreen(
        isScrollControlled: true,
        enableDrag: false,
        isDismissible: true,
        context: context,
        builder: (context) => ref.watch(selectedPaymentMethodProvider).isEmpty
            ? const ChoosePaymentTypeSheet()
            : const TipSheet(),
      );
    }
  }

  _validateForm({
    required WidgetRef ref,
    required String firstName,
    required String lastName,
    required String phone,
    required String email,
  }) {
    if (firstName.isEmpty) {
      FormValidator().firstName(ref);
    } else {
      ref.read(firstNameErrorProvider.notifier).state = null;
    }
    if (lastName.isEmpty) {
      FormValidator().lastName(ref);
    } else {
      ref.read(lastNameErrorProvider.notifier).state = null;
    }

    if (phone.length != 10) {
      FormValidator().phone(ref);
    } else {
      ref.read(phoneErrorProvider.notifier).state = null;
    }
    if (!EmailValidator.validate(email)) {
      FormValidator().email(ref);
    } else {
      ref.read(emailErrorProvider.notifier).state = null;
    }

    if (ref.read(emailErrorProvider.notifier).state == null &&
        ref.read(firstNameErrorProvider.notifier).state == null &&
        ref.read(lastNameErrorProvider.notifier).state == null &&
        ref.read(phoneErrorProvider.notifier).state == null) {
      ref.read(formValidatedProvider.notifier).state = true;
    }
  }
}
