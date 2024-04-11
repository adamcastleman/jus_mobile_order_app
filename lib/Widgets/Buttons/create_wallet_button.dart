import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/payments.dart';
import 'package:jus_mobile_order_app/Models/payments_model.dart';
import 'package:jus_mobile_order_app/Models/user_model.dart';
import 'package:jus_mobile_order_app/Providers/loading_providers.dart';
import 'package:jus_mobile_order_app/Providers/payments_providers.dart';
import 'package:jus_mobile_order_app/Services/payment_services.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/elevated_button_large.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/elevated_button_large_loading.dart';
import 'package:jus_mobile_order_app/errors.dart';

class CreateWalletButton extends ConsumerWidget {
  final UserModel user;
  final int loadAmount;
  final PaymentsModel creditCard;
  const CreateWalletButton(
      {required this.loadAmount,
      required this.creditCard,
      required this.user,
      super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final applePaySelected = ref.watch(applePaySelectedProvider);
    final applePayLoading = ref.watch(applePayLoadingProvider);
    final loading = ref.watch(loadingProvider);

    if (applePayLoading || loading) {
      return const LargeElevatedLoadingButton();
    } else {
      return LargeElevatedButton(
        buttonText: 'Create Wallet',
        onPressed: () => _handlePayment(context, ref, applePaySelected),
      );
    }
  }

  _handlePayment(BuildContext context, WidgetRef ref, bool applePaySelected) {
    if (creditCard.cardId == null || creditCard.cardId!.isEmpty) {
      PaymentsHelpers.showPaymentErrorModal(
          context, ref, ErrorMessage.paymentMethodNotSelected);
      return;
    }
    if (applePaySelected) {
      ref.read(applePayLoadingProvider.notifier).state = true;
      _createWalletUsingApplePay(context, ref);
    } else {
      ref.read(loadingProvider.notifier).state = true;
      _callCreateWalletCloudFunction(context, ref, creditCard.cardId ?? '');
    }
  }

  void _createWalletUsingApplePay(BuildContext context, WidgetRef ref) {
    PaymentServices().generateSecureCardDetailsFromApplePay(
      ref: ref,
      amount: _formatLoadAmountForSubmit(),
      onSuccess: (cardDetails) =>
          _callCreateWalletCloudFunction(context, ref, cardDetails.nonce),
      onError: (error) =>
          PaymentsHelpers.showPaymentErrorModal(context, ref, error),
    );
  }

  void _callCreateWalletCloudFunction(
      BuildContext context, WidgetRef ref, String cardId) {
    Map<String, dynamic> orderDetails =
        PaymentsHelpers.generateCreateWalletOrderDetails(
      user: user,
      cardId: cardId,
      loadAmount: _formatLoadAmountForSubmit(),
    );
    PaymentServices.createWalletCloudFunction(
      orderDetails,
      onSuccess: () {
        ref.read(loadingProvider.notifier).state = false;
        PaymentsHelpers.onWalletActivitySuccess(context,
            message: 'Created Wallet');
      },
      onError: (error) {
        ref.read(loadingProvider.notifier).state = false;
        PaymentsHelpers.showPaymentErrorModal(context, ref, error);
      },
    );
  }

  _formatLoadAmountForSubmit() {
    return (loadAmount * 100).floor().toString();
  }
}
