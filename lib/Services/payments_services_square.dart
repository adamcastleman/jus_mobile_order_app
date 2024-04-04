import 'dart:async';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/utilities.dart';
import 'package:jus_mobile_order_app/Models/user_model.dart';
import 'package:jus_mobile_order_app/Providers/loading_providers.dart';
import 'package:jus_mobile_order_app/Providers/payments_providers.dart';
import 'package:jus_mobile_order_app/Services/payment_method_database_services.dart';
import 'package:jus_mobile_order_app/theme_data.dart';
import 'package:square_in_app_payments/in_app_payments.dart';
import 'package:square_in_app_payments/models.dart';

typedef PaymentFormCallback = Future<void> Function(String, String);
typedef PaymentSuccessCallback = void Function(CardDetails result);
typedef PaymentErrorCallback = void Function(String errorMessage);

class SquarePaymentServices {
  Future setApplicationID() async {
    final HttpsCallableResult result = await FirebaseFunctions.instance
        .httpsCallable('secrets')
        .call({'secretKey': 'square-application-id-sandbox'});
    final String squareAppID = result.data;
    await InAppPayments.setSquareApplicationId(squareAppID);
  }

  Future getApplicationId() async {
    final HttpsCallableResult result = await FirebaseFunctions.instance
        .httpsCallable('secrets')
        .call({'secretKey': 'square-application-id-sandbox'});
    return result.data;
  }

  Future<String> _getSquareApplePayMerchantId() async {
    final HttpsCallableResult result = await FirebaseFunctions.instance
        .httpsCallable('secrets')
        .call({'secretKey': 'apple-pay-merchant-id'});

    return result.data;
  }

  void requestCreditCardNonceFromSquareInAppPaymentsSdk({
    required Function(CardDetails) onSuccess,
    required VoidCallback onCancel,
  }) async {
    if (PlatformUtils.isIOS()) {
      ThemeManager().setIOSCardEntryTheme(isMembershipMigration: false);
    }

    await InAppPayments.startCardEntryFlow(
      collectPostalCode: false,
      onCardNonceRequestSuccess: (cardDetails) async {
        onSuccess(cardDetails);
      },
      onCardEntryCancel: () {
        onCancel();
      },
    );
  }

  requestGiftCardNonceFromSquareInAppPaymentsSdk({
    required Function(CardDetails) onSuccess,
    required VoidCallback onCancel,
  }) async {
    //Gift cards can not be used as a payment method for an order. The only action
    //a user can take on a physical gift card is to transfer to their Wallet (digital gift card).
    if (PlatformUtils.isIOS()) {
      ThemeManager().setIOSCardEntryTheme(isMembershipMigration: false);
    }
    await InAppPayments.startGiftCardEntryFlow(
      onCardNonceRequestSuccess: (CardDetails cardDetails) async {
        onSuccess(cardDetails);
        await InAppPayments.completeCardEntry(onCardEntryComplete: () {});
      },
      onCardEntryCancel: () {
        onCancel();
      },
    );
  }

  requestApplePayNonceFromSquareInAppPaymentsSdk({
    required String price,
    required Function(CardDetails) onSuccess,
    required VoidCallback onComplete,
    required Function(String) onFailure,
    required Function(String) onError,
  }) async {
    String squareApplePayMerchantId = await _getSquareApplePayMerchantId();
    bool canUseApplePay = await InAppPayments.canUseApplePay;

    if (!canUseApplePay) {
      return;
    }
    await InAppPayments.initializeApplePay(squareApplePayMerchantId);
    return await InAppPayments.requestApplePayNonce(
      price: '${int.parse(price) / 100}',
      summaryLabel: 'Jus, Inc.',
      countryCode: 'US',
      currencyCode: 'USD',
      paymentType: ApplePayPaymentType.finalPayment,
      onApplePayNonceRequestSuccess: (result) async {
        _completeApplePayAuthorization(
          isSuccess: true,
        );
        onSuccess(result);
      },
      onApplePayNonceRequestFailure: (error) async {
        _completeApplePayAuthorization(
          isSuccess: false,
          error: error.message,
        );
        onFailure(error.message);
      },
      onApplePayComplete: () {
        onComplete();
      },
    );
  }

  Future _completeApplePayAuthorization(
      {required bool isSuccess, String? error}) async {
    await InAppPayments.completeApplePayAuthorization(
        isSuccess: isSuccess, errorMessage: error ?? '');
  }

  Future<String?> inputSquareCreditCardForMembershipMigration(
      {required VoidCallback onCardEntryCancel}) async {
    var completer = Completer<String?>();
    if (PlatformUtils.isIOS()) {
      ThemeManager().setIOSCardEntryTheme(isMembershipMigration: true);
    }
    await InAppPayments.startCardEntryFlow(
      collectPostalCode: false,
      onCardNonceRequestSuccess: (CardDetails result) async {
        completer.complete(result.nonce);
        try {
          await InAppPayments.completeCardEntry(onCardEntryComplete: () {});
        } on Exception catch (ex) {
          InAppPayments.showCardNonceProcessingError(ex.toString());
        }
      },
      onCardEntryCancel: () {
        completer.complete(null);
        onCardEntryCancel();
      },
    );
    return completer.future;
  }

  void initializeSquarePaymentsSdk({
    required WidgetRef ref,
    required PaymentFormCallback onInitialized,
    required PaymentErrorCallback onCardEntryError,
  }) async {
    try {
      String applicationId = await SquarePaymentServices().getApplicationId();
      // final locationId = ref.watch(selectedLocationProvider).squareLocationId;
      ///TODO get the real square locationId
      String locationId = 'LPRZ3G3PWZBKF';
      await onInitialized(applicationId, locationId);
      // Logic to capture payment form result and process payment
      // This part depends on how WebPayment.showForm returns the result
    } on Exception catch (ex) {
      onCardEntryError(ex.toString());
    }
  }

  Future<void> processCardDetails({
    required WidgetRef ref,
    required UserModel user,
    required Map cardDetails,
    required Function(String) onPaymentError,
  }) async {
    try {
      if (user.uid == null) {
        _handleGuestUser(ref, cardDetails, user);
      } else {
        await _handleRegisteredUser(user, cardDetails);
      }
    } catch (ex) {
      onPaymentError(ex.toString());
    }
    try {
      if (PlatformUtils.isIOS() || PlatformUtils.isAndroid()) {
        await InAppPayments.completeCardEntry(onCardEntryComplete: () {});
      }
    } on Exception {
      if (PlatformUtils.isIOS() || PlatformUtils.isAndroid()) {
        await InAppPayments.completeCardEntry(onCardEntryComplete: () {});
      }
    }
  }

  void _handleGuestUser(WidgetRef ref, Map cardDetails, UserModel user) {
    //Guests: only one payment method can be stored at a time. Entering a
    //new card will override the previously entered one.
    ref
        .read(selectedPaymentMethodProvider.notifier)
        .updateSelectedPaymentMethod(
          user: user,
          cardNickname: user.firstName ?? '',
          cardId: cardDetails['nonce'],
          brand: cardDetails['brand'],
          last4: cardDetails['last4'],
          gan: '',
          isWallet: false,
        );
  }

  Future<void> _handleRegisteredUser(UserModel user, Map cardDetails) async {
    //Users: We store the card to the database and set it as the default
    //payment so it can be used automatically without selection.
    Map card = await PaymentMethodDatabaseServices().getCardIdFromNonce(
        user.squareCustomerId!, cardDetails['cardId'] ?? cardDetails['nonce']);
    await PaymentMethodDatabaseServices().addPaymentCardToDatabase(
      cardId: card['cardId'],
      brand: card['cardBrand'],
      last4: card['last4'],
      expirationMonth: card['expMonth'],
      expirationYear: card['expYear'],
      isWallet: false,
      firstName: user.firstName ?? '',
    );
  }

  Future<void> updateSquareSubscriptionPaymentMethod(
      {required String squareCustomerId, required String cardId}) async {
    try {
      await FirebaseFunctions.instance
          .httpsCallable('updateSubscriptionPaymentMethod')
          .call({
        'squareCustomerId': squareCustomerId,
        'cardId': cardId,
      });
    } catch (e) {
      throw Exception(
        'There was an error updating your subscription',
      );
    }
  }

  transferGiftCardBalance(
      {required WidgetRef ref,
      required String walletGan,
      required String firstName,
      required String email,
      required String walletUID,
      required String physicalCardGan,
      required int physicalCardAmount}) async {
    var response = await FirebaseFunctions.instance
        .httpsCallable('transferGiftCardBalance')
        .call({
      'cardDetails': {
        'gan': walletGan,
      },
      'userDetails': {
        'firstName': firstName,
        'email': email,
      },
      'paymentDetails': {
        'amount': physicalCardAmount,
      },
      'metadata': {
        'walletUID': walletUID,
        'physicalCardGan': physicalCardGan,
      }
    });
    ref.read(loadingProvider.notifier).state = false;
    ref.invalidate(selectedLoadAmountProvider);
    ref.invalidate(selectedLoadAmountIndexProvider);
    return response;
  }
}
