import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Providers/loading_providers.dart';
import 'package:jus_mobile_order_app/Providers/payments_providers.dart';
import 'package:jus_mobile_order_app/Services/payments_services_square.dart';
import 'package:square_in_app_payments/models.dart';

class PaymentServices {
  void generateSecureCardDetailsFromApplePay({
    required WidgetRef ref,
    required String amount,
    required Function(CardDetails) onSuccess,
    required Function(String) onError,
  }) {
    SquarePaymentServices().requestApplePayNonceFromSquareInAppPaymentsSdk(
        price: amount,
        onSuccess: (cardDetails) {
          onSuccess(cardDetails);
        },
        onComplete: () {
          onApplePayNonceFunctionComplete(ref);
        },
        onFailure: (error) {
          onApplePayNonceFunctionComplete(ref);
          onError(error);
        },
        onError: (error) {
          onError(error);
        });
  }

  generateSecureCardDetailsFromCreditCardInAppPaymentsSdk({
    required WidgetRef ref,
    required Function(CardDetails) onSuccess,
    required VoidCallback onCancel,
  }) {
    SquarePaymentServices().requestCreditCardNonceFromSquareInAppPaymentsSdk(
        onSuccess: (cardDetails) {
      onSuccess(cardDetails);
    }, onCancel: () {
      onCancel();
    });
  }

  generateSecureCardDetailsFromGiftCardInAppPaymentsSdk({
    required WidgetRef ref,
    required Function(CardDetails) onSuccess,
    required VoidCallback onCancel,
  }) {
    SquarePaymentServices().requestGiftCardNonceFromSquareInAppPaymentsSdk(
        onSuccess: (cardDetails) {
      onSuccess(cardDetails);
    }, onCancel: () {
      onCancel();
    });
  }

  static onApplePayNonceFunctionComplete(WidgetRef ref) {
    ref.invalidate(applePayLoadingProvider);
    ref.invalidate(selectedLoadAmountProvider);
    ref.invalidate(selectedLoadAmountIndexProvider);
  }

  static void createWalletCloudFunction(
    Map<String, dynamic> orderDetails, {
    required VoidCallback onSuccess,
    required Function(String) onError,
  }) async {
    var result = await FirebaseFunctions.instance
        .httpsCallable('createDigitalGiftCard')
        .call({'orderMap': orderDetails});
    if (result.data == 200) {
      onSuccess();
    } else {
      onError(
          'There was an error creating your Wallet. Please try again later.');
    }
  }

  static void addFundsToWalletCloudFunction(
    Map<String, dynamic> orderDetails, {
    required VoidCallback onSuccess,
    required Function(String) onError,
  }) async {
    var result = await FirebaseFunctions.instance
        .httpsCallable('addFundsToWallet')
        .call({'orderMap': orderDetails});
    if (result.data == 200) {
      onSuccess();
    } else {
      onError(
          'There was an error processing this transaction. Please try again later.');
    }
  }

  static void createOrderCloudFunction({
    required Map<String, dynamic> orderDetails,
    required VoidCallback onPaymentSuccess,
    required Function(String) onError,
  }) async {
    final result = await FirebaseFunctions.instance
        .httpsCallable('createOrder')
        .call({'orderMap': orderDetails});

    if (result.data['status'] == 200) {
      onPaymentSuccess();
    } else {
      onError(
          'There was an error processing this order. Please try again later.');
    }
  }
}
