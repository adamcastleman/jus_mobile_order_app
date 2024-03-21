import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/orders.dart';
import 'package:jus_mobile_order_app/Helpers/payments.dart';
import 'package:jus_mobile_order_app/Helpers/wallet.dart';
import 'package:jus_mobile_order_app/Models/payments_model.dart';
import 'package:jus_mobile_order_app/Models/user_model.dart';
import 'package:jus_mobile_order_app/Providers/loading_providers.dart';
import 'package:jus_mobile_order_app/Providers/payments_providers.dart';
import 'package:jus_mobile_order_app/Services/payment_services.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/elevated_button_large.dart';

import '../../Helpers/error.dart';

class LoadWalletAndPayButton extends ConsumerWidget {
  final UserModel user;
  final PaymentsModel wallet;
  final PaymentsModel creditCard;

  const LoadWalletAndPayButton({
    required this.wallet,
    required this.creditCard,
    required this.user,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loadAmount = ref.watch(selectedLoadAmountProvider) ??
        WalletHelpers().getDefaultLoadAmount(ref, user, wallet.balance ?? 0);
    final formattedAmount = formatAmount(loadAmount);

    return LargeElevatedButton(
      buttonText: 'Add \$$formattedAmount to Wallet x${wallet.last4} and pay',
      onPressed: () => _onPressed(context, ref, loadAmount),
    );
  }

  String formatAmount(int amountInCents) {
    return (amountInCents / 100).toStringAsFixed(2);
  }

  void _onPressed(BuildContext context, WidgetRef ref, int loadAmount) {
    HapticFeedback.lightImpact();
    String? failedValidationMessage = OrderHelpers.validateOrder(context, ref);

    if (failedValidationMessage != null) {
      ErrorHelpers.showSinglePopError(context, error: failedValidationMessage);
      return;
    }

    if (!WalletHelpers.isWalletBalanceSufficientToCoverTransaction(
        ref, wallet.balance ?? 0, user)) {
      ErrorHelpers.showSinglePopError(context,
          error: 'Insufficient wallet balance to cover the order.');
      return;
    }

    if (wallet.gan == null || wallet.gan!.isEmpty) {
      ErrorHelpers.showSinglePopError(context,
          error: 'Please choose a payment method.');
      return;
    }

    _handlePayment(context, ref, loadAmount);
  }

  void _handlePayment(BuildContext context, WidgetRef ref, int loadAmount) {
    final applePaySelected = ref.watch(applePaySelectedProvider);
    final totals = PaymentsHelpers.generateOrderPricingDetails(ref, user);
    Map<String, dynamic> orderDetails =
        PaymentsHelpers().generateOrderDetails(ref, user, totals);

    if (applePaySelected) {
      _processApplePay(context, ref, orderDetails, loadAmount);
    } else {
      orderDetails['paymentDetails']['cardId'] = creditCard.cardId;
      _addFundsToWalletAndPay(context, ref, orderDetails, loadAmount);
    }
  }

  void _processApplePay(BuildContext context, WidgetRef ref,
      Map<String, dynamic> orderDetails, int loadAmount) {
    ref.read(applePayLoadingProvider.notifier).state = true;
    PaymentServices().generateSecureCardDetailsFromApplePay(
      ref: ref,
      amount: loadAmount.toString(),
      onSuccess: (cardDetails) {
        orderDetails['paymentDetails']['cardId'] = cardDetails.nonce;
        _addFundsToWalletAndPay(context, ref, orderDetails, loadAmount);
      },
      onError: (error) =>
          PaymentsHelpers.showPaymentErrorModal(context, ref, error),
    );
  }

  void _addFundsToWalletAndPay(BuildContext context, WidgetRef ref,
      Map<String, dynamic> orderDetails, int loadAmount) {
    ref.read(loadingProvider.notifier).state = true;
    Map<String, dynamic> walletDetails =
        PaymentsHelpers.generateAddFundsToWalletOrderDetails(
      user: user,
      cardId: creditCard.cardId ?? '',
      gan: wallet.gan ?? '',
      walletUid: wallet.uid ?? '',
      loadAmount: (loadAmount).floor().toString(),
    );
    PaymentServices.addFundsToWalletCloudFunction(
      walletDetails,
      onSuccess: () {
        orderDetails['paymentDetails']['cardId'] = wallet.gan;
        return PaymentServices.createOrderCloudFunction(
          orderDetails: orderDetails,
          onPaymentSuccess: () =>
              PaymentsHelpers.showPaymentSuccessModal(context),
          onError: (error) =>
              PaymentsHelpers.showPaymentErrorModal(context, ref, error),
        );
      },
      onError: (error) {
        PaymentsHelpers.showPaymentErrorModal(context, ref, error);
      },
    );
  }
}
