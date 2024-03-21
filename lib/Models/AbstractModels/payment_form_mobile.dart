import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/error.dart';
import 'package:jus_mobile_order_app/Models/AbstractModels/abstract_payment_form.dart';
import 'package:jus_mobile_order_app/Models/user_model.dart';
import 'package:jus_mobile_order_app/Providers/loading_providers.dart';
import 'package:jus_mobile_order_app/Providers/payments_providers.dart';
import 'package:jus_mobile_order_app/Services/payment_services.dart';
import 'package:jus_mobile_order_app/Services/payments_services_square.dart';

class PaymentFormMobile extends PaymentFormManager {
  @override
  void generateCreditCardPaymentForm(
      {required BuildContext context,
      required WidgetRef ref,
      required UserModel user,
      VoidCallback? onSuccess}) {
    PaymentServices().generateSecureCardDetailsFromCreditCardInAppPaymentsSdk(
      ref: ref,
      onSuccess: (result) {
        Map cardDetails = {
          'cardId': result.nonce,
          'last4': result.card.lastFourDigits,
          'brand': result.card.brand.name,
        };

        SquarePaymentServices().processCardDetails(
          ref: ref,
          user: user,
          cardDetails: cardDetails,
          onPaymentError: (error) =>
              ErrorHelpers.showSinglePopError(context, error: error),
        );
        onSuccess != null ? onSuccess() : null;
      },
      onCancel: () {
        ref.read(loadingProvider.notifier).state = false;
      },
    );
  }

  @override
  void generateGiftCardPaymentForm(
      {required BuildContext context,
      required WidgetRef ref,
      required UserModel user,
      VoidCallback? onSuccess}) {
    PaymentServices().generateSecureCardDetailsFromGiftCardInAppPaymentsSdk(
      ref: ref,
      onSuccess: (result) async {
        var response = await FirebaseFunctions.instance
            .httpsCallable('getGiftCardBalanceFromNonce')
            .call({'nonce': result.nonce});
        ref.read(physicalGiftCardBalanceProvider.notifier).state =
            response.data;
        onSuccess != null ? onSuccess() : null;
      },
      onCancel: () {
        ref.read(loadingProvider.notifier).state = false;
      },
    );
  }

  @override
  void generateCreditCardPaymentFormForSubscription(
      {required BuildContext context,
      required WidgetRef ref,
      required UserModel user,
      required Function(String) onSuccess}) {
    PaymentServices().generateSecureCardDetailsFromCreditCardInAppPaymentsSdk(
      ref: ref,
      onSuccess: (result) {
        onSuccess(result.nonce);
      },
      onCancel: () {
        ref.read(loadingProvider.notifier).state = false;
      },
    );
  }

  @override
  void generateCreditCardPaymentFormForMembershipMigration(
      {required BuildContext context,
      required WidgetRef ref,
      required Function(String) onSuccess}) {
    PaymentServices().generateSecureCardDetailsFromCreditCardInAppPaymentsSdk(
      ref: ref,
      onSuccess: (result) {
        onSuccess(result.nonce);
      },
      onCancel: () {
        ref.read(loadingProvider.notifier).state = false;
      },
    );
  }
}

PaymentFormManager getManager() => PaymentFormMobile();
