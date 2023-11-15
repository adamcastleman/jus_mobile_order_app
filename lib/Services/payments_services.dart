import 'dart:async';
import 'dart:io';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:jus_mobile_order_app/Helpers/enums.dart';
import 'package:jus_mobile_order_app/Helpers/error.dart';
import 'package:jus_mobile_order_app/Helpers/modal_bottom_sheets.dart';
import 'package:jus_mobile_order_app/Helpers/payments.dart';
import 'package:jus_mobile_order_app/Helpers/pricing.dart';
import 'package:jus_mobile_order_app/Models/payments_model.dart';
import 'package:jus_mobile_order_app/Models/user_model.dart';
import 'package:jus_mobile_order_app/Providers/loading_providers.dart';
import 'package:jus_mobile_order_app/Providers/location_providers.dart';
import 'package:jus_mobile_order_app/Providers/payments_providers.dart';
import 'package:jus_mobile_order_app/Services/payment_methods_services.dart';
import 'package:jus_mobile_order_app/Sheets/invalid_sheet_single_pop.dart';
import 'package:jus_mobile_order_app/Sheets/order_confirmation_sheet.dart';
import 'package:jus_mobile_order_app/theme_data.dart';
import 'package:square_in_app_payments/in_app_payments.dart';
import 'package:square_in_app_payments/models.dart';

class PaymentsServices {
  final String? userID;
  final String? firstName;
  final WidgetRef? ref;
  final BuildContext? context;

  PaymentsServices({this.context, this.ref, this.userID, this.firstName});

  Future setApplicationID() async {
    final HttpsCallableResult result = await FirebaseFunctions.instance
        .httpsCallable('secrets')
        .call({'secretKey': 'square-application-id-sandbox'});
    final String squareAppID = result.data;
    await InAppPayments.setSquareApplicationId(squareAppID);
  }

  Future<String?> enterPaymentMethodForMembershipMigration(
      {required VoidCallback onCardEntryCancel}) async {
    var completer = Completer<String?>();
    if (Platform.isIOS) {
      ThemeManager().setIOSCardEntryTheme(isMembershipTransfer: true);
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

  initApplePayPayment(BuildContext context, UserModel user) async {
    final buildContext = context;
    SelectedPaymentMethodNotifier reference =
        ref!.read(selectedPaymentMethodProvider.notifier);
    var price = NumberFormat('0.00', 'en_US').format(
        user.uid == null || !user.isActiveMember!
            ? Pricing(ref: ref!).orderTotalForNonMembers()
            : Pricing(ref: ref!).orderTotalForMembers());

    final HttpsCallableResult result = await FirebaseFunctions.instance
        .httpsCallable('secrets')
        .call({'secretKey': 'apple-pay-merchant-id'});
    final String squareApplePayMerchantID = result.data;
    bool canUseApplePay = await InAppPayments.canUseApplePay;

    if (canUseApplePay) {
      await InAppPayments.initializeApplePay(squareApplePayMerchantID);
      try {
        await InAppPayments.requestApplePayNonce(
          price: price,
          summaryLabel: 'Jus, Inc.',
          countryCode: 'US',
          currencyCode: 'USD',
          paymentType: ApplePayPaymentType.finalPayment,
          onApplePayNonceRequestSuccess: (result) async {
            PaymentMethodsServices().updatePaymentMethod(
              reference: reference,
              cardNickname: firstName,
              nonce: result.nonce,
              brand: result.card.brand.name,
              isWallet: false,
              lastFourDigits: result.card.lastFourDigits,
            );
            PaymentsHelper(ref: ref!).processPayment(buildContext, user);
          },
          onApplePayNonceRequestFailure: (info) async {
            ref!.invalidate(applePayLoadingProvider);
          },
          onApplePayComplete: () {
            ref!.invalidate(applePayLoadingProvider);
          },
        );
      } on PlatformException catch (ex) {
        ref!.invalidate(applePayLoadingProvider);
        throw ex.message.toString();
      }
    }
  }

  initApplePayWalletLoad(
      {required BuildContext context,
      required UserModel user,
      PaymentsModel? wallet}) async {
    SelectedPaymentMethodNotifier reference =
        ref!.read(selectedPaymentMethodProvider.notifier);
    final loadAmount = ref!.watch(loadAmountsProvider);
    final selectedLoadAmountIndex = ref!.watch(selectedLoadAmountIndexProvider);
    final walletType = ref!.watch(walletTypeProvider);
    final HttpsCallableResult result = await FirebaseFunctions.instance
        .httpsCallable('secrets')
        .call({'secretKey': 'apple-pay-merchant-id'});
    final String squareApplePayMerchantID = result.data;
    bool canUseApplePay = await InAppPayments.canUseApplePay;
    if (canUseApplePay) {
      await InAppPayments.initializeApplePay(squareApplePayMerchantID);
      try {
        await InAppPayments.requestApplePayNonce(
          price: (loadAmount[selectedLoadAmountIndex] / 100).toStringAsFixed(2),
          summaryLabel: 'Jus, Inc.',
          countryCode: 'US',
          currencyCode: 'USD',
          paymentType: ApplePayPaymentType.finalPayment,
          onApplePayNonceRequestSuccess: (result) async {
            PaymentMethodsServices().updatePaymentMethod(
              reference: reference,
              cardNickname: firstName,
              nonce: result.nonce,
              brand: result.card.brand.name,
              isWallet: false,
              lastFourDigits: result.card.lastFourDigits,
            );
            if (walletType == WalletType.createWallet) {
              createWallet(context, user);
            } else {
              addFundsToWallet(context, user, wallet!);
            }

            ref!.read(applePayLoadingProvider.notifier).state = false;
            ref!.invalidate(selectedLoadAmountProvider);
            ref!.invalidate(selectedLoadAmountIndexProvider);
            await InAppPayments.completeApplePayAuthorization(
                isSuccess: true, errorMessage: 'There was an error');
          },
          onApplePayNonceRequestFailure: (info) async {
            await InAppPayments.completeApplePayAuthorization(
                isSuccess: false, errorMessage: 'There was an error');
            ref!.invalidate(applePayLoadingProvider);
            ref!.invalidate(selectedLoadAmountProvider);
            ref!.invalidate(selectedLoadAmountIndexProvider);
          },
          onApplePayComplete: () {
            ref!.invalidate(applePayLoadingProvider);
            ref!.invalidate(selectedLoadAmountProvider);
            ref!.invalidate(selectedLoadAmountIndexProvider);
          },
        );
      } on PlatformException catch (ex) {
        ref!.invalidate(applePayLoadingProvider);
        ref!.invalidate(selectedLoadAmountProvider);
        ref!.invalidate(selectedLoadAmountIndexProvider);
        throw ex.message.toString();
      }
    }
  }

  initSquarePayment() async {
    if (Platform.isIOS) {
      ThemeManager().setIOSCardEntryTheme(isMembershipTransfer: false);
    }
    _inputCreditCard();
  }

  initSquareGiftCardPayment() {
    if (Platform.isIOS) {
      ThemeManager().setIOSCardEntryTheme(isMembershipTransfer: false);
    }
    _inputGiftCard();
  }

  _inputCreditCard() async {
    // To ensure the Square In-App Payments modal can validate cards asynchronously
    // and update the initial stored value for guest cards, pass a reference
    // to the selectedPaymentMethod provider when updating payment methods.
    // For registered users, the default card provider automatically updates
    // the selectedPaymentMethod provider, so this is not a concern for them.
    // Passing the reference ensures proper updates for all payment methods
    // without destabilizing the ref.read() method that occurs when called directly
    // in async functions.
    SelectedPaymentMethodNotifier reference =
        ref!.read(selectedPaymentMethodProvider.notifier);

    await InAppPayments.startCardEntryFlow(
        collectPostalCode: false,
        onCardNonceRequestSuccess: (CardDetails result) {
          _onCardEntryCardNonceRequestSuccess(
              reference: reference, result: result, isWallet: false);
        },
        onCardEntryCancel: () {});
  }

  Future _inputGiftCard() async {
    //^^Same basic idea as above. We are in an async function, so we cannot
    //trust the stability of the reference when trying to update the provider.
    //We must store a reference to the notifier before the async work in order
    //to maintain stability of the provider state changes after we return the
    //data from the cloud function.
    StateController reference =
        ref!.read(physicalGiftCardBalanceProvider.notifier);
    await InAppPayments.startGiftCardEntryFlow(
      onCardNonceRequestSuccess: (CardDetails result) async {
        var response = await FirebaseFunctions.instance
            .httpsCallable('getGiftCardBalanceFromNonce')
            .call({'nonce': result.nonce});
        reference.state = response.data;

        await InAppPayments.completeCardEntry(onCardEntryComplete: () {});
      },
      onCardEntryCancel: () {},
    );
  }

  void _onCardEntryCardNonceRequestSuccess({
    required SelectedPaymentMethodNotifier reference,
    required CardDetails result,
    required bool isWallet,
  }) async {
    if (userID != null) {
      //Cloud function handles updating all new cards as the new default payment,
      //and un-defaults the previous default payment method. This is all that's needed,
      //because the selectedPaymentMethodProvider is a StateNotifier and is listening to
      //the defaultPaymentMethod stream, and auto-updating the selectedPaymentsMethodProvider
      //when it hears a new value.
      PaymentMethodsServices().addPaymentCardToDatabase(
        nonce: result.nonce,
        brand: result.card.brand.name == 'squareGiftCard'
            ? 'Wallet'
            : result.card.brand.name,
        lastFourDigits: result.card.lastFourDigits,
        expirationMonth: result.card.expirationMonth,
        expirationYear: result.card.expirationYear,
        isWallet: isWallet,
        firstName: firstName ?? '',
      );
    } else {
      //if guest is checking out - there is not a call to the database,
      //and there is no concept of a default card. Only one payment method can be stored
      //at a time for a guest, and entering a new card will override the previously entered one.
      //Therefore, the selectedPaymentMethod provider must be manually updated each time .
      PaymentMethodsServices().updatePaymentMethod(
        reference: reference,
        cardNickname: firstName,
        nonce: result.nonce,
        brand: result.card.brand.name,
        isWallet: isWallet,
        lastFourDigits: result.card.lastFourDigits,
      );
    }

    try {
      await InAppPayments.completeCardEntry(onCardEntryComplete: () {});
    } on Exception catch (ex) {
      InAppPayments.showCardNonceProcessingError(ex.toString());
    }
  }

  chargeCardAndCreateOrder(UserModel user) {
    final totals = PaymentsHelper(ref: ref).calculatePricingAndTotals(user);
    final orderMap = PaymentsHelper(ref: ref).generateOrderMap(user, totals);
    final result = FirebaseFunctions.instance
        .httpsCallable('createOrder')
        .call({'orderMap': orderMap})
        .then((value) => value)
        .catchError((onError) {
          ref!.invalidate(loadingProvider);
          ModalBottomSheet().partScreen(
            context: context!,
            builder: (context) => InvalidSheetSinglePop(
              error: onError.toString(),
            ),
          );
          return Future<HttpsCallableResult>.error(onError);
        });
    return result;
  }

  void handlePaymentResult(BuildContext context, dynamic result) async {
    if (result.data['status'] == 200) {
      _showSuccessModal(context);
      await InAppPayments.completeApplePayAuthorization(
          isSuccess: true, errorMessage: 'There was an error');
    } else {
      _showErrorModal(context, result.data['message']);
    }
  }

  void createWallet(BuildContext context, UserModel user) async {
    final selectedPayment = ref!.watch(selectedPaymentMethodProvider);
    final loadAmount = ref!.watch(loadAmountsProvider);
    final selectedLoadAmountIndex = ref!.watch(selectedLoadAmountIndexProvider);
    Map giftCardMap = {
      'paymentDetails': {
        'nonce': selectedPayment['nonce'],
        'amount': loadAmount[selectedLoadAmountIndex],
        'currency': 'USD',
      },
      'userDetails': {
        'firstName': user.firstName,
        'email': user.email,
      },
      'cardDetails': {
        'type': 'DIGITAL',
      },
    };
    await FirebaseFunctions.instance
        .httpsCallable('createDigitalGiftCard')
        .call({'giftCardMap': giftCardMap});

    ref!.read(loadingProvider.notifier).state = false;
    ref!.invalidate(selectedLoadAmountProvider);
    ref!.invalidate(selectedLoadAmountIndexProvider);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.pop(context);
    });
  }

  transferGiftCardBalance(
      {required String walletGan,
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
    ref!.read(loadingProvider.notifier).state = false;
    ref!.invalidate(selectedLoadAmountProvider);
    ref!.invalidate(selectedLoadAmountIndexProvider);
    return response;
  }

  void addFundsToWallet(
      BuildContext context, UserModel user, PaymentsModel wallet) async {
    final selectedPayment = ref!.watch(selectedPaymentMethodProvider);
    final selectedWallet = ref!.watch(currentlySelectedWalletProvider);
    final loadAmount = ref!.watch(loadAmountsProvider);
    final selectedLoadAmountIndex = ref!.watch(selectedLoadAmountIndexProvider);
    Map orderMap = {
      'paymentDetails': {
        'nonce': selectedPayment['nonce'],
        'gan': selectedWallet.isEmpty ? wallet.gan : selectedWallet['gan'],
        'amount': loadAmount[selectedLoadAmountIndex],
        'currency': 'USD',
      },
      'userDetails': {
        'firstName': user.firstName,
        'email': user.email,
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
      ModalBottomSheet().partScreen(
        context: context,
        builder: (context) => const InvalidSheetSinglePop(
            error: 'Something went wrong. Please try again later'),
      );
    }

    ref!.read(loadingProvider.notifier).state = false;
    ref!.invalidate(selectedLoadAmountProvider);
    ref!.invalidate(selectedLoadAmountIndexProvider);
  }

  void addFundsToWalletAndPay(
      BuildContext context, UserModel user, PaymentsModel wallet) async {
    final selectedWallet = ref!.watch(currentlySelectedWalletProvider);
    final totals = PaymentsHelper(ref: ref).calculatePricingAndTotals(user);
    final orderMap = PaymentsHelper(ref: ref).generateOrderMap(user, totals);
    final loadAmount = ref!.watch(loadAmountsProvider);
    final selectedLoadAmountIndex = ref!.watch(selectedLoadAmountIndexProvider);
    final selectedLocation = ref!.watch(selectedLocationProvider);

    try {
      var result = await FirebaseFunctions.instance
          .httpsCallable('loadMoneyAndPay')
          .call({
        'orderMap': orderMap,
        'metadata': {
          'paymentDetails': {
            'walletUID':
                selectedWallet.isEmpty ? wallet.uid : selectedWallet['uid'],
            'amount': loadAmount[selectedLoadAmountIndex],
            'currency': selectedLocation.currency,
          }
        }
      });
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pop(context);
        handlePaymentResult(context, result);
      });
    } catch (e) {
      ModalBottomSheet().partScreen(
        context: context,
        builder: (context) => const InvalidSheetSinglePop(
            error: 'Something went wrong. Please try again later'),
      );
    }

    ref!.read(loadingProvider.notifier).state = false;
    ref!.invalidate(selectedLoadAmountProvider);
    ref!.invalidate(selectedLoadAmountIndexProvider);
  }

  void _showSuccessModal(BuildContext context) {
    ref!.invalidate(loadingProvider);
    Navigator.pop(context);
    Navigator.pop(context);

    ModalBottomSheet().fullScreen(
      context: context,
      builder: (context) => const OrderConfirmationSheet(),
    );
  }

  void _showErrorModal(BuildContext context, String message) {
    ref!.invalidate(loadingProvider);
    Navigator.pop(context);
    ModalBottomSheet().partScreen(
      context: context,
      enableDrag: true,
      isScrollControlled: true,
      isDismissible: true,
      builder: (context) {
        return InvalidSheetSinglePop(
          error: SquarePaymentsErrors().getSquareErrorMessage(message),
        );
      },
    );
  }
}
