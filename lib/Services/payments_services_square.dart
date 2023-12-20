import 'dart:async';
import 'dart:io';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/enums.dart';
import 'package:jus_mobile_order_app/Helpers/modal_bottom_sheets.dart';
import 'package:jus_mobile_order_app/Models/payments_model.dart';
import 'package:jus_mobile_order_app/Models/user_model.dart';
import 'package:jus_mobile_order_app/Providers/loading_providers.dart';
import 'package:jus_mobile_order_app/Providers/payments_providers.dart';
import 'package:jus_mobile_order_app/Services/payment_method_database_services.dart';
import 'package:jus_mobile_order_app/Sheets/invalid_sheet_single_pop.dart';
import 'package:jus_mobile_order_app/theme_data.dart';
import 'package:square_in_app_payments/in_app_payments.dart';
import 'package:square_in_app_payments/models.dart';

class SquarePaymentServices {
  Future setApplicationID() async {
    final HttpsCallableResult result = await FirebaseFunctions.instance
        .httpsCallable('secrets')
        .call({'secretKey': 'square-application-id-sandbox'});
    final String squareAppID = result.data;
    await InAppPayments.setSquareApplicationId(squareAppID);
  }

  Future<String> _getSquareApplePayMerchantId() async {
    final HttpsCallableResult result = await FirebaseFunctions.instance
        .httpsCallable('secrets')
        .call({'secretKey': 'apple-pay-merchant-id'});

    return result.data;
  }

  Future<String?> inputSquareCreditCardForMembershipMigration(
      {required VoidCallback onCardEntryCancel}) async {
    var completer = Completer<String?>();
    if (Platform.isIOS) {
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

  inputSquareCreditCard(WidgetRef ref, UserModel user) async {
    if (Platform.isIOS) {
      ThemeManager().setIOSCardEntryTheme(isMembershipMigration: false);
    }
    await InAppPayments.startCardEntryFlow(
      collectPostalCode: false,
      onCardNonceRequestSuccess: (CardDetails result) async {
        if (user.uid == null) {
          //Guests: only one payment method can be stored at a time. Entering a
          //new card will override the previously entered one.
          ref
              .read(selectedPaymentMethodProvider.notifier)
              .updateSelectedPaymentMethod(card: {
            'cardId': result.nonce,
            'last4': result.card.lastFourDigits,
            'brand': result.card.brand,
            'cardNickname': user.firstName ?? '',
            'gan': null,
            'balance': null,
            'isWallet': false,
          });
        } else {
          //Users: We store the card to the database and set it as the default
          //payment so it can be used automatically without selection.
          Map card = await PaymentMethodDatabaseServices()
              .getCardIdFromNonce(user.squareCustomerId!, result.nonce);
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
        try {
          await InAppPayments.completeCardEntry(onCardEntryComplete: () {});
        } on Exception catch (ex) {
          InAppPayments.showCardNonceProcessingError(ex.toString());
        }
      },
      onCardEntryCancel: () {},
    );
  }

  inputSquareGiftCard(WidgetRef ref) async {
    //Gift cards can not be used as a payment method for an order. The only action
    //a user can take on a physical gift card is to transfer to their Wallet (digital gift card).
    if (Platform.isIOS) {
      ThemeManager().setIOSCardEntryTheme(isMembershipMigration: false);
    }
    await InAppPayments.startGiftCardEntryFlow(
      onCardNonceRequestSuccess: (CardDetails result) async {
        var response = await FirebaseFunctions.instance
            .httpsCallable('getGiftCardBalanceFromNonce')
            .call({'nonce': result.nonce});
        ref.read(physicalGiftCardBalanceProvider.notifier).state =
            response.data;
        await InAppPayments.completeCardEntry(onCardEntryComplete: () {});
      },
      onCardEntryCancel: () {},
    );
  }

  initApplePayPayment({
    required Function(CardDetails) onSuccess,
    required VoidCallback onFailure,
    required VoidCallback onComplete,
    required String priceInDollars,
  }) async {
    bool canUseApplePay = await InAppPayments.canUseApplePay;
    if (canUseApplePay) {
      String squareApplePayMerchantId = await _getSquareApplePayMerchantId();
      await InAppPayments.initializeApplePay(squareApplePayMerchantId);
      try {
        await InAppPayments.requestApplePayNonce(
          price: priceInDollars,
          summaryLabel: 'Jus, Inc.',
          countryCode: 'US',
          currencyCode: 'USD',
          paymentType: ApplePayPaymentType.finalPayment,
          onApplePayNonceRequestSuccess: (result) {
            onSuccess(result);
          },
          onApplePayNonceRequestFailure: (info) {
            onFailure();
          },
          onApplePayComplete: () {
            onComplete();
          },
        );
      } on PlatformException catch (ex) {
        throw ex.message.toString();
      }
    }
  }

  initApplePayWalletLoad(
      {required BuildContext context,
      required WidgetRef ref,
      required UserModel user,
      PaymentsModel? wallet}) async {
    SelectedPaymentMethodNotifier reference =
        ref.read(selectedPaymentMethodProvider.notifier);
    final loadAmount = ref.watch(walletLoadAmountsProvider);
    final selectedLoadAmountIndex = ref.watch(selectedLoadAmountIndexProvider);
    final walletType = ref.watch(walletTypeProvider);
    String squareApplePayMerchantId = await _getSquareApplePayMerchantId();
    bool canUseApplePay = await InAppPayments.canUseApplePay;
    if (canUseApplePay) {
      await InAppPayments.initializeApplePay(squareApplePayMerchantId);
      try {
        await InAppPayments.requestApplePayNonce(
          price: (loadAmount[selectedLoadAmountIndex] / 100).toStringAsFixed(2),
          summaryLabel: 'Jus, Inc.',
          countryCode: 'US',
          currencyCode: 'USD',
          paymentType: ApplePayPaymentType.finalPayment,
          onApplePayNonceRequestSuccess: (result) async {
            PaymentMethodDatabaseServices().updatePaymentMethod(
              reference: reference,
              cardNickname: user.firstName ?? '',
              cardId: result.nonce,
              brand: result.card.brand.name,
              isWallet: false,
              last4: result.card.lastFourDigits,
            );
            if (walletType == WalletType.createWallet) {
              createWallet(context, ref, user);
            } else {
              addFundsToWallet(context, ref, user, wallet!, onError: (error) {
                ModalBottomSheet().partScreen(
                  context: context,
                  builder: (context) => const InvalidSheetSinglePop(
                      error: 'Something went wrong. Please try again later'),
                );
              });
            }

            ref.read(applePayLoadingProvider.notifier).state = false;
            ref.invalidate(selectedLoadAmountProvider);
            ref.invalidate(selectedLoadAmountIndexProvider);
            await InAppPayments.completeApplePayAuthorization(
                isSuccess: true, errorMessage: 'There was an error');
          },
          onApplePayNonceRequestFailure: (info) async {
            await InAppPayments.completeApplePayAuthorization(
                isSuccess: false, errorMessage: 'There was an error');
            ref.invalidate(applePayLoadingProvider);
            ref.invalidate(selectedLoadAmountProvider);
            ref.invalidate(selectedLoadAmountIndexProvider);
          },
          onApplePayComplete: () {
            ref.invalidate(applePayLoadingProvider);
            ref.invalidate(selectedLoadAmountProvider);
            ref.invalidate(selectedLoadAmountIndexProvider);
          },
        );
      } on PlatformException catch (ex) {
        ref.invalidate(applePayLoadingProvider);
        ref.invalidate(selectedLoadAmountProvider);
        ref.invalidate(selectedLoadAmountIndexProvider);
        throw ex.message.toString();
      }
    }
  }

  Future completeApplePayAuthorization({required bool isSuccess}) async {
    await InAppPayments.completeApplePayAuthorization(
        isSuccess: isSuccess, errorMessage: 'There was an error');
  }

  void createWallet(BuildContext context, WidgetRef ref, UserModel user) async {
    final selectedPayment = ref.watch(selectedPaymentMethodProvider);
    final loadAmount = ref.watch(walletLoadAmountsProvider);
    final selectedLoadAmountIndex = ref.watch(selectedLoadAmountIndexProvider);
    Map giftCardMap = {
      'paymentDetails': {
        'cardId': selectedPayment['cardId'],
        'amount': loadAmount[selectedLoadAmountIndex],
        'currency': 'USD',
      },
      'userDetails': {
        'firstName': user.firstName,
        'email': user.email,
        'squareCustomerId': user.squareCustomerId,
      },
      'cardDetails': {
        'type': 'DIGITAL',
      },
    };
    await FirebaseFunctions.instance
        .httpsCallable('createDigitalGiftCard')
        .call({'giftCardMap': giftCardMap});

    ref.read(loadingProvider.notifier).state = false;
    ref.invalidate(selectedLoadAmountProvider);
    ref.invalidate(selectedLoadAmountIndexProvider);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.pop(context);
    });
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

  void addFundsToWallet(
      BuildContext context, WidgetRef ref, UserModel user, PaymentsModel wallet,
      {required Function(String) onError}) async {
    final selectedPayment = ref.watch(selectedPaymentMethodProvider);
    final selectedWallet = ref.watch(currentlySelectedWalletProvider);
    final loadAmount = ref.watch(walletLoadAmountsProvider);
    final selectedLoadAmountIndex = ref.watch(selectedLoadAmountIndexProvider);
    Map orderMap = {
      'paymentDetails': {
        'cardId': selectedPayment['cardId'],
        'gan': selectedWallet.isEmpty ? wallet.gan : selectedWallet['gan'],
        'amount': loadAmount[selectedLoadAmountIndex],
        'currency': 'USD',
      },
      'userDetails': {
        'firstName': user.firstName,
        'email': user.email,
        'squareCustomerId': user.squareCustomerId,
      },
      'metadata': {
        'walletUID':
            selectedWallet.isEmpty ? wallet.uid : selectedWallet['uid'],
      }
    };
    try {
      await FirebaseFunctions.instance
          .httpsCallable('addFundsToWallet')
          .call({'orderMap': orderMap});
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pop(context);
        Navigator.pop(context);
      });
    } catch (e) {
      onError(e.toString());
    }

    ref.read(loadingProvider.notifier).state = false;
    ref.invalidate(selectedLoadAmountProvider);
    ref.invalidate(selectedLoadAmountIndexProvider);
  }

  void addFundsToWalletAndPay({
    required String walletUid,
    required Map<String, dynamic> orderMap,
    required int loadAmount,
    required String currency,
    required VoidCallback onSuccess,
    required Function(String) onError,
  }) async {
    try {
      var result = await FirebaseFunctions.instance
          .httpsCallable('loadMoneyAndPay')
          .call({
        'orderMap': orderMap,
        'metadata': {
          'paymentDetails': {
            'walletUID': walletUid,
            'amount': loadAmount,
            'currency': currency,
          }
        }
      });

      if (result.data == 200 || result.data == '200') {
        onSuccess();
      } else {
        throw Exception('Payment processing failed');
      }
    } catch (e) {
      onError(e.toString());
    }
  }

  void processPayment({
    required Map<String, dynamic> orderMap,
    required VoidCallback onPaymentSuccess,
    required Function(String) onError,
  }) async {
    try {
      final result = await FirebaseFunctions.instance
          .httpsCallable('createOrder')
          .call({'orderMap': orderMap});

      if (result.data['status'] == 200) {
        onPaymentSuccess();
      } else {
        throw Exception(result.data['message']);
      }
    } catch (e) {
      onError(e.toString());
    }
  }
}
