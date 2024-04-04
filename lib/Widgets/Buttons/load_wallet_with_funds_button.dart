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

class LoadWalletWithFundsButton extends ConsumerWidget {
  final UserModel user;
  final PaymentsModel wallet;
  final PaymentsModel creditCard;
  final int loadAmount;

  const LoadWalletWithFundsButton(
      {required this.creditCard,
      required this.user,
      required this.wallet,
      required this.loadAmount,
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
        buttonText:
            'Add \$${loadAmount.toStringAsFixed(2)} to Wallet x${wallet.last4}',
        onPressed: () {
          _handlePayment(context, ref, applePaySelected);
        },
      );
    }
  }

  _handlePayment(
    BuildContext context,
    WidgetRef ref,
    bool applePaySelected,
  ) {
    if (creditCard.cardId == null || creditCard.cardId!.isEmpty) {
      PaymentsHelpers.showPaymentErrorModal(
          context, ref, ErrorMessage.paymentMethodNotSelected);
      return;
    }
    if (applePaySelected) {
      ref.read(applePayLoadingProvider.notifier).state = true;
      _addFundsToWalletUsingApplePay(context, ref);
    } else {
      ref.read(loadingProvider.notifier).state = true;
      _callAddFundsCloudFunction(context, ref, creditCard.cardId ?? '');
    }
  }

  void _addFundsToWalletUsingApplePay(BuildContext context, WidgetRef ref) {
    PaymentServices().generateSecureCardDetailsFromApplePay(
      ref: ref,
      amount: (loadAmount * 100).floor().toString(),
      onSuccess: (cardDetails) {
        _callAddFundsCloudFunction(context, ref, cardDetails.nonce);
      },
      onError: (error) {
        PaymentsHelpers.showPaymentErrorModal(context, ref, error);
      },
    );
  }

  void _callAddFundsCloudFunction(
      BuildContext context, WidgetRef ref, String cardId) {
    Map<String, dynamic> orderDetails =
        PaymentsHelpers.generateAddFundsToWalletOrderDetails(
      user: user,
      cardId: cardId,
      gan: wallet.gan ?? '',
      walletUid: wallet.uid ?? '',
      loadAmount: (loadAmount * 100).floor().toString(),
    );
    PaymentServices.addFundsToWalletCloudFunction(
      orderDetails,
      onSuccess: () {
        PaymentsHelpers.onWalletActivitySuccess(context,
            message: 'Funds Added to Wallet');
      },
      onError: (error) {
        PaymentsHelpers.showPaymentErrorModal(context, ref, error);
      },
    );
  }
}
