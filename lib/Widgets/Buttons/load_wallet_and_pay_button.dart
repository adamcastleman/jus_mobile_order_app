import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/modal_bottom_sheets.dart';
import 'package:jus_mobile_order_app/Helpers/orders.dart';
import 'package:jus_mobile_order_app/Helpers/payments.dart';
import 'package:jus_mobile_order_app/Helpers/wallet.dart';
import 'package:jus_mobile_order_app/Models/payments_model.dart';
import 'package:jus_mobile_order_app/Models/user_model.dart';
import 'package:jus_mobile_order_app/Providers/loading_providers.dart';
import 'package:jus_mobile_order_app/Providers/location_providers.dart';
import 'package:jus_mobile_order_app/Providers/payments_providers.dart';
import 'package:jus_mobile_order_app/Services/payments_services_square.dart';
import 'package:jus_mobile_order_app/Sheets/invalid_sheet_single_pop.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/elevated_button_large.dart';

class LoadWalletAndPayButton extends ConsumerWidget {
  final UserModel user;
  final PaymentsModel wallet;
  final VoidCallback onSuccess;
  final Function(String) onError;

  const LoadWalletAndPayButton(
      {required this.wallet,
      required this.user,
      required this.onSuccess,
      required this.onError,
      super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return LargeElevatedButton(
        buttonText: getPaymentButtonText(ref, user, wallet),
        onPressed: () {
          ref.read(loadingProvider.notifier).state = true;
          bool isValidated = _validatePayment(context, ref);
          if (isValidated) {
            HapticFeedback.lightImpact();
            _handlePayment(context: context, ref: ref, user: user);
          }
        });
  }

  String getPaymentButtonText(
      WidgetRef ref, UserModel user, PaymentsModel wallet) {
    final walletHelpers = WalletHelpers(ref: ref);
    final selectedLoadAmount = ref.watch(selectedLoadAmountProvider);
    final walletAmount = walletHelpers.walletAmount(wallet);
    final amount = selectedLoadAmount ??
        walletHelpers.loadAndPayWalletAmount(ref, user, walletAmount);
    final formattedAmount = (amount / 100).toStringAsFixed(2);

    return 'Add \$$formattedAmount to Wallet and pay';
  }

  bool _validatePayment(BuildContext context, WidgetRef ref) {
    final walletHelpers = WalletHelpers(ref: ref);
    final walletAmount = walletHelpers.walletAmount(wallet);
    final failedValidationMessage =
        OrderHelpers(ref: ref).validateOrder(context);
    final selectedPayment = ref.watch(selectedPaymentMethodProvider);

    if (!WalletHelpers(ref: ref)
        .isWalletBalanceSufficientToCoverTransaction(ref, walletAmount, user)) {
      invalidateWalletProviders(ref);
      ModalBottomSheet().partScreen(
        context: context,
        builder: (context) => const InvalidSheetSinglePop(
          error: 'You cannot cover the order total with this amount.',
        ),
      );
      return false;
    }

    if (failedValidationMessage != null) {
      invalidateWalletProviders(ref);
      OrderHelpers(ref: ref)
          .showInvalidOrderModal(context, failedValidationMessage);
      return false;
    }

    if (selectedPayment.isEmpty) {
      invalidateWalletProviders(ref);
      WalletHelpers(ref: ref).displayInvalidPaymentError(context);
      return false;
    }

    return true; // All validations passed
  }

  void _handlePayment({
    required BuildContext context,
    required WidgetRef ref,
    required UserModel user,
  }) {
    final applePaySelected = ref.watch(applePaySelectedProvider);
    final paymentsServices = SquarePaymentServices();

    if (applePaySelected) {
      ref.read(applePayLoadingProvider.notifier).state = true;
      paymentsServices.initApplePayWalletLoad(
          context: context, ref: ref, user: user);
    } else {
      addFundsToWalletAndPay(context, ref, user, paymentsServices, wallet);
    }
  }

  addFundsToWalletAndPay(BuildContext context, WidgetRef ref, UserModel user,
      SquarePaymentServices paymentsServices, PaymentsModel wallet) {
    ref.read(loadingProvider.notifier).state = true;
    final selectedWallet = ref.watch(currentlySelectedWalletProvider);
    final totals = PaymentsHelper(ref: ref).calculatePricingAndTotals(user);
    final orderMap = PaymentsHelper(ref: ref).generateOrderMap(user, totals);
    final loadAmount = ref.watch(walletLoadAmountsProvider);
    final selectedLoadAmountIndex = ref.watch(selectedLoadAmountIndexProvider);
    final selectedLocation = ref.watch(selectedLocationProvider);
    paymentsServices.addFundsToWalletAndPay(
      orderMap: orderMap,
      walletUid: selectedWallet.isEmpty ? wallet.uid : selectedWallet['uid'],
      loadAmount: loadAmount[selectedLoadAmountIndex],
      currency: selectedLocation.currency,
      onSuccess: () {
        onSuccess();
      },
      onError: (error) {
        onError(error);
      },
    );
  }
}
