import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/error.dart';
import 'package:jus_mobile_order_app/Helpers/modal_bottom_sheets.dart';
import 'package:jus_mobile_order_app/Helpers/payments.dart';
import 'package:jus_mobile_order_app/Helpers/points.dart';
import 'package:jus_mobile_order_app/Helpers/pricing.dart';
import 'package:jus_mobile_order_app/Helpers/products.dart';
import 'package:jus_mobile_order_app/Models/payments_model.dart';
import 'package:jus_mobile_order_app/Models/user_model.dart';
import 'package:jus_mobile_order_app/Providers/auth_providers.dart';
import 'package:jus_mobile_order_app/Providers/location_providers.dart';
import 'package:jus_mobile_order_app/Providers/order_providers.dart';
import 'package:jus_mobile_order_app/Providers/payments_providers.dart';
import 'package:jus_mobile_order_app/Providers/points_providers.dart';
import 'package:jus_mobile_order_app/Sheets/order_confirmation_sheet.dart';
import 'package:jus_mobile_order_app/Widgets/Payments/invalid_payment_sheet.dart';
import 'package:jus_mobile_order_app/theme_data.dart';
import 'package:square_in_app_payments/in_app_payments.dart';
import 'package:square_in_app_payments/models.dart';

class PaymentsServices {
  final String? userID;
  final String? firstName;
  final WidgetRef? ref;
  final BuildContext? context;
  final ProviderContainer container = ProviderContainer();

  PaymentsServices({this.context, this.ref, this.userID, this.firstName});

  Stream<List<PaymentsModel>> get squareCreditCards {
    CollectionReference collectionReference = FirebaseFirestore.instance
        .collection('users')
        .doc(userID)
        .collection('squarePaymentMethods');
    return collectionReference
        .where('isGiftCard', isNotEqualTo: true)
        .snapshots()
        .map(getPaymentCardsFromDatabase);
  }

  Stream<List<PaymentsModel>> get squareGiftCards {
    CollectionReference collectionReference = FirebaseFirestore.instance
        .collection('users')
        .doc(userID)
        .collection('squarePaymentMethods');
    return collectionReference
        .where('isGiftCard', isEqualTo: true)
        .snapshots()
        .map(getPaymentCardsFromDatabase);
  }

  Stream<PaymentsModel> get defaultPaymentCard {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(userID)
        .collection('squarePaymentMethods')
        .where('defaultPayment', isEqualTo: true)
        .snapshots()
        .map(getDefaultCardFromDatabase);
  }

  PaymentsModel getDefaultCardFromDatabase(QuerySnapshot snapshot) {
    return snapshot.docs.map(
      (doc) {
        final dynamic data = doc.data();

        return PaymentsModel(
          uid: data['uid'],
          userID: data['userID'],
          nonce: data['nonce'],
          brand: data['brand'],
          isGiftCard: data['isGiftCard'],
          lastFourDigits: data['lastFourDigits'],
          expirationMonth: data['expirationMonth'],
          expirationYear: data['expirationYear'],
          defaultPayment: data['defaultPayment'],
          cardNickname: data['cardNickname'],
        );
      },
    ).first;
  }

  List<PaymentsModel> getPaymentCardsFromDatabase(QuerySnapshot snapshot) {
    return snapshot.docs.map(
      (doc) {
        final dynamic data = doc.data();
        return PaymentsModel(
          uid: data['uid'],
          userID: data['userID'],
          nonce: data['nonce'],
          brand: data['brand'],
          isGiftCard: data['isGiftCard'],
          lastFourDigits: data['lastFourDigits'],
          expirationMonth: data['expirationMonth'],
          expirationYear: data['expirationYear'],
          defaultPayment: data['defaultPayment'],
          cardNickname: data['cardNickname'],
        );
      },
    ).toList();
  }

  addPaymentCardToDatabase({
    required String nonce,
    required String brand,
    required String lastFourDigits,
    required int expirationMonth,
    required int expirationYear,
    required String postalCode,
    required bool isGiftCard,
    required String firstName,
  }) async {
    try {
      final HttpsCallable callable =
          FirebaseFunctions.instance.httpsCallable('addSavedPaymentToDatabase');
      await callable.call({
        'nonce': nonce,
        'brand': brand,
        'lastFourDigits': lastFourDigits,
        'expirationMonth': expirationMonth,
        'expirationYear': expirationYear,
        'postalCode': postalCode,
        'isGiftCard': isGiftCard,
        'firstName': firstName,
      });
    } catch (e) {
      return;
      // Handle the error as needed
    }
  }

  Future setApplicationID() async {
    await InAppPayments.setSquareApplicationId('sq0idp-sTnvNvgfZ8wGZr9x7uxsmA');
  }

  initSquarePayment() {
    setApplicationID();
    if (Platform.isIOS) {
      ThemeManager().setIOSCardEntryTheme();
    }
    inputCreditCard();
  }

  initSquareGiftCardPayment() {
    setApplicationID();
    if (Platform.isIOS) {
      ThemeManager().setIOSCardEntryTheme();
    }
    inputGiftCard();
  }

  inputCreditCard() async {
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
        onCardNonceRequestSuccess: (CardDetails result) {
          _onCardEntryCardNonceRequestSuccess(
              reference: reference, result: result, isGiftCard: false);
        },
        onCardEntryCancel: () {});
  }

  Future inputGiftCard() async {
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
    await InAppPayments.startGiftCardEntryFlow(
        onCardNonceRequestSuccess: (CardDetails result) {
          _onCardEntryCardNonceRequestSuccess(
              reference: reference, result: result, isGiftCard: true);
        },
        onCardEntryCancel: () {});
  }

  void _onCardEntryCardNonceRequestSuccess({
    required SelectedPaymentMethodNotifier reference,
    required CardDetails result,
    required bool isGiftCard,
  }) async {
    if (userID != null) {
      //Cloud function handles updating all new cards as the new default payment,
      //and un-defaults the previous default payment method. This is all that's needed,
      //because the selectedPaymentMethodProvider is a StateNotifier and is listening to
      //the defaultPaymentMethod stream, and auto-updating the selectedPaymentsMethodProvider
      //when it hears a new value.
      addPaymentCardToDatabase(
        nonce: result.nonce,
        brand: result.card.brand.name == 'squareGiftCard'
            ? 'giftCard'
            : result.card.brand.name,
        lastFourDigits: result.card.lastFourDigits,
        expirationMonth: result.card.expirationMonth,
        expirationYear: result.card.expirationYear,
        postalCode: result.card.postalCode!,
        isGiftCard: isGiftCard,
        firstName: firstName ?? '',
      );
    } else {
      //if guest is checking out - there is not call to the database,
      //and there is no concept of a default card. Only one payment method can be stored
      //at a time for a guest, and entering a new card will override the previously entered one.
      //Therefore, the selectedPaymentMethodProvider must be manually updated each time .
      PaymentsHelper().updatePaymentMethod(
        reference: reference,
        cardNickname: firstName,
        nonce: result.nonce,
        brand: result.card.brand.name,
        isGiftCard: isGiftCard,
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
    final totals = _calculatePricingAndTotals(user);
    final orderMap = _generateOrderMap(user, totals);

    final result = FirebaseFunctions.instance
        .httpsCallable('createOrder')
        .call({'orderMap': orderMap})
        .then((value) => value)
        .catchError((onError) {
          ref!.invalidate(loadingProvider);
          ModalBottomSheet().partScreen(
            context: context!,
            builder: (context) => InvalidDatabaseEntrySheet(
              error: onError.toString(),
            ),
          );
          return Future<HttpsCallableResult>.error(onError);
        });
    return result;
  }

  Map<String, int> _calculatePricingAndTotals(UserModel user) {
    final pricing = Pricing(ref: ref);
    final isMember = user.uid != null && user.isActiveMember == true;
    final originalSubtotal = isMember
        ? pricing.originalSubtotalForMembers()
        : pricing.originalSubtotalForNonMembers();
    final discountedSubtotal = isMember
        ? pricing.discountedSubtotalForMembers()
        : pricing.discountedSubtotalForNonMembers();
    final tax = isMember
        ? pricing.totalTaxForMembers()
        : pricing.totalTaxForNonMembers();
    final discountTotal = isMember
        ? pricing.discountTotalForMembers()
        : pricing.discountTotalForNonMembers();
    final tipTotal = isMember
        ? pricing.tipAmountForMembers()
        : pricing.tipAmountForNonMembers();

    final totalInCents = ((discountedSubtotal + tax) * 100).round();
    final originalSubtotalInCents = (originalSubtotal * 100).round();
    final discountedSubtotalInCents = (discountedSubtotal * 100).round();
    final taxTotalInCents = (tax * 100).round();
    final tipTotalInCents = (tipTotal * 100).round();
    final discountTotalInCents = (discountTotal * 100).round();

    return {
      'originalSubtotalInCents': originalSubtotalInCents,
      'totalInCents': totalInCents,
      'discountedSubtotalInCents': discountedSubtotalInCents,
      'taxTotalInCents': taxTotalInCents,
      'tipTotalInCents': tipTotalInCents,
      'discountTotalInCents': discountTotalInCents,
    };
  }

  Map<String, dynamic> _generateOrderMap(
      UserModel user, Map<String, int?> totals) {
    final selectedLocation = ref!.watch(selectedLocationProvider);
    final selectedCard = ref!.watch(selectedPaymentMethodProvider);
    final pickupTime = ref!.watch(selectedPickupTimeProvider);
    final pickupDate = ref!.watch(selectedPickupDateProvider);
    final scheduleAllItems = ref!.watch(scheduleAllItemsProvider);

    final guestFirstName = ref!.watch(firstNameProvider);
    final guestLastName = ref!.watch(lastNameProvider);
    final guestEmail = ref!.watch(emailProvider);
    final guestPhone = ref!.watch(phoneProvider);

    final items = ProductHelpers(ref: ref!).generateProductList();
    final points = PointsHelper(ref: ref!).totalEarnedPoints();
    final pointsInUse = ref!.watch(pointsInUseProvider);

    final int totalInCents = totals['totalInCents'] ?? 0;
    final int tipTotalInCents = totals['tipTotalInCents'] ?? 0;
    final nonce =
        totalInCents + tipTotalInCents == 0 ? null : selectedCard['nonce'];
    final paymentMethod =
        totalInCents + tipTotalInCents == 0 ? 'storeCredit' : 'card';

    return {
      'isGuest': user.uid == null ? true : false,
      'guestFirstName': guestFirstName,
      'guestLastName': guestLastName,
      'guestEmail': guestEmail,
      'guestPhone': guestPhone,
      'locationID': selectedLocation.locationID,
      'items': items,
      'paymentSource':
          Platform.isIOS || Platform.isAndroid ? 'Mobile Order' : 'Web Order',
      'externalPaymentType':
          paymentMethod == 'storeCredit' ? 'STORED_BALANCE' : '',
      'pickupTime': pickupTime?.millisecondsSinceEpoch,
      'pickupDate': pickupDate?.millisecondsSinceEpoch,
      'scheduleAllItems': scheduleAllItems,
      'paymentMethod': paymentMethod,
      'nonce': nonce,
      'totalAmount': totals['totalInCents'],
      'originalSubtotalAmount': totals['originalSubtotalInCents'],
      'discountedSubtotalAmount': totals['discountedSubtotalInCents'],
      'discountAmount': totals['discountTotalInCents'],
      'taxAmount': totals['taxTotalInCents'],
      'tipAmount': totals['tipTotalInCents'],
      'pointsEarned': points,
      'pointsRedeemed': pointsInUse,
    };
  }

  void handlePaymentResult(BuildContext context, dynamic result) {
    final status = result.data;

    if (status == 200) {
      _showSuccessModal(context);
    } else {
      _showErrorModal(context, result.data['message']);
    }
  }

  void _showSuccessModal(BuildContext context) {
    ref!.invalidate(loadingProvider);

    Navigator.pop(context);
    Navigator.pop(context);
    HapticFeedback.heavyImpact();

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
          return InvalidDatabaseEntrySheet(
            error: SquarePaymentsErrors().getSquareErrorMessage(message),
          );
        });
  }

  updateCardNickname(
      {required BuildContext context,
      required String cardNickname,
      required String cardID}) async {
    try {
      await FirebaseFunctions.instance
          .httpsCallable('updateCardNickname')
          .call({'cardID': cardID, 'cardNickname': cardNickname});
      ref!.invalidate(cardNicknameProvider);
    } catch (e) {
      return ModalBottomSheet().partScreen(
        context: context,
        builder: (context) => InvalidDatabaseEntrySheet(
          error: e.toString(),
        ),
      );
    }
  }

  updateDefaultPayment(BuildContext context, String cardID) async {
    try {
      await FirebaseFunctions.instance
          .httpsCallable('updateDefaultPayment')
          .call({'cardID': cardID});
    } catch (e) {
      return ModalBottomSheet().partScreen(
        context: context,
        builder: (context) => InvalidDatabaseEntrySheet(
          error: e.toString(),
        ),
      );
    }
  }

  deletePaymentMethod(BuildContext context, String cardID) async {
    try {
      await FirebaseFunctions.instance
          .httpsCallable('deletePaymentMethod')
          .call({'cardID': cardID});
    } catch (e) {
      return ModalBottomSheet().partScreen(
        context: context,
        builder: (context) => InvalidDatabaseEntrySheet(
          error: e.toString(),
        ),
      );
    }
  }
}
