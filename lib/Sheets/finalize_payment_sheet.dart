import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/enums.dart';
import 'package:jus_mobile_order_app/Helpers/payment_methods.dart';
import 'package:jus_mobile_order_app/Helpers/pricing.dart';
import 'package:jus_mobile_order_app/Helpers/spacing_widgets.dart';
import 'package:jus_mobile_order_app/Helpers/utilities.dart';
import 'package:jus_mobile_order_app/Models/payments_model.dart';
import 'package:jus_mobile_order_app/Models/user_model.dart';
import 'package:jus_mobile_order_app/Providers/loading_providers.dart';
import 'package:jus_mobile_order_app/Providers/payments_providers.dart';
import 'package:jus_mobile_order_app/Providers/stream_providers.dart';
import 'package:jus_mobile_order_app/Providers/theme_providers.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/add_payment_method_button.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/close_button.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/no_charge_button.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/open_load_money_and_pay_sheet_button.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/pay_with_apple_pay_button.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/process_payment_button.dart';
import 'package:jus_mobile_order_app/Widgets/General/tip_container.dart';
import 'package:jus_mobile_order_app/Widgets/General/total_price.dart';
import 'package:jus_mobile_order_app/constants.dart';

class FinalizePaymentSheet extends ConsumerWidget {
  const FinalizePaymentSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider).value!;
    final backgroundColor = ref.watch(backgroundColorProvider);
    final bool isDrawerOpen =
        AppConstants.scaffoldKey.currentState?.isEndDrawerOpen ?? false;

    // Use a LayoutBuilder for responsive layout decisions
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return isDrawerOpen
            ? _drawerOpenLayout(context, ref, backgroundColor, user)
            : _drawerClosedLayout(context, ref, backgroundColor, user);
      },
    );
  }

  Widget _drawerOpenLayout(BuildContext context, WidgetRef ref,
      Color backgroundColor, UserModel user) {
    return Container(
      padding: const EdgeInsets.all(22.0),
      height: MediaQuery.of(context).size.height,
      child: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                _tippingContainer(backgroundColor),
                _paymentSection(context, ref, user),
              ],
            ),
          ),
          const Positioned(
            top: 0,
            right: 0,
            child: JusCloseButton(),
          )
        ],
      ),
    );
  }

  Widget _drawerClosedLayout(BuildContext context, WidgetRef ref,
      Color backgroundColor, UserModel user) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(25),
        ),
        color: backgroundColor,
      ),
      padding: const EdgeInsets.only(bottom: 40.0, left: 8.0, right: 8.0),
      child: Wrap(
        children: [
          Spacing.vertical(30),
          _tippingContainer(backgroundColor),
          _paymentSection(context, ref, user),
        ],
      ),
    );
  }

  Widget _paymentSection(BuildContext context, WidgetRef ref, UserModel user) {
    return Column(
      children: [
        const TotalPrice(),
        Spacing.vertical(40),
        displayPaymentButtons(context, ref, user),
      ],
    );
  }

  Widget _tippingContainer(Color backgroundColor) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: backgroundColor,
      ),
      padding: const EdgeInsets.only(
          top: 20.0, bottom: 40.0, left: 12.0, right: 12.0),
      child: const Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: TipContainer(),
          ),
        ],
      ),
    );
  }

  Widget displayPaymentButtons(
      BuildContext context, WidgetRef ref, UserModel user) {
    if (PricingHelpers().isZeroCharge(ref)) {
      return NoChargePaymentButton(user: user);
    }

    if (PlatformUtils.isIOS()) {
      final applePaySelected = ref.watch(applePaySelectedProvider);
      return applePaySelected
          ? PayWithApplePayButton(user: user)
          : Column(
              children: [
                _determineCreditCardButton(context, ref, user),
                Spacing.vertical(8),
                PayWithApplePayButton(user: user),
              ],
            );
    }
    return _determineCreditCardButton(context, ref, user);
  }

  Widget _determineCreditCardButton(
      BuildContext context, WidgetRef ref, UserModel user) {
    return _hasSelectedPaymentMethod(ref)
        ? _processPaymentButton(context, ref, user)
        : _addPaymentMethodButton(context, ref, user);
  }

  bool _hasSelectedPaymentMethod(WidgetRef ref) {
    final selectedPaymentMethod = ref.watch(selectedPaymentMethodProvider);

    // If the selected payment method is a wallet
    if (selectedPaymentMethod.isWallet) {
      // Check if 'gan' is NOT null or empty, return true if it's valid (not null or empty), otherwise false
      return selectedPaymentMethod.gan != null &&
          selectedPaymentMethod.gan!.isNotEmpty;
    } else {
      // For non-wallet payment methods, check if 'cardId' is NOT null or empty
      // Return true if 'cardId' is valid (not null or empty), otherwise false
      return selectedPaymentMethod.cardId != null &&
          selectedPaymentMethod.cardId!.isNotEmpty;
    }
  }

  Widget _addPaymentMethodButton(
      BuildContext context, WidgetRef ref, UserModel user) {
    return AddPaymentMethodButton(
      onPressed: () => PaymentMethodHelpers().addCreditCardAsSelectedPayment(
        context,
        ref,
        user,
        onSuccess: () {
          ref.read(squarePaymentSkdLoadingProvider.notifier).state = false;
          if (PlatformUtils.isWeb()) {
            Navigator.pop(context);
            Navigator.pop(context);
          }
        },
      ),
    );
  }

  Widget _processPaymentButton(
      BuildContext context, WidgetRef ref, UserModel user) {
    final selectedPayment = ref.watch(selectedPaymentMethodProvider);
    final totalPrice = _getTotalPrice(ref, user);

    if (_isBalanceInsufficient(selectedPayment, totalPrice)) {
      return const OpenLoadMoneyAndPaySheetButton();
    }

    return ProcessCreditCardPaymentButton(
      user: user,
    );
  }

  double _getTotalPrice(WidgetRef ref, UserModel user) {
    return user.uid == null || user.subscriptionStatus!.isNotActive
        ? PricingHelpers().orderTotalForNonMembers(ref) * 100
        : PricingHelpers().orderTotalForMembers(ref) * 100;
  }

  bool _isBalanceInsufficient(
      PaymentsModel? selectedPayment, double totalPrice) {
    if (selectedPayment == null) return false;

    if (!selectedPayment.isWallet) return false;

    if (selectedPayment.balance == null) return true;

    return totalPrice > selectedPayment.balance!;
  }
}
