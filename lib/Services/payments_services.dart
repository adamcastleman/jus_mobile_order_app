import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/modal_bottom_sheets.dart';
import 'package:jus_mobile_order_app/Models/payments_model.dart';
import 'package:jus_mobile_order_app/Providers/payments_providers.dart';
import 'package:jus_mobile_order_app/Sheets/order_confirmation_sheet.dart';
import 'package:square_in_app_payments/in_app_payments.dart';
import 'package:square_in_app_payments/models.dart';

class PaymentsServices {
  final String? uid;
  final String? firstName;
  final WidgetRef? ref;
  final BuildContext? context;

  PaymentsServices({this.context, this.ref, this.uid, this.firstName});

  Stream<List<PaymentsModel>> get squareCreditCards {
    CollectionReference collectionReference = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('squareCreditCards');
    return collectionReference.snapshots().map(getPaymentCardsFromDatabase);
  }

  Stream<List<PaymentsModel>> get defaultPaymentCard {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('squareCreditCards')
        .where('defaultPayment', isEqualTo: true)
        .snapshots()
        .map(getPaymentCardsFromDatabase);
  }

  addPaymentCardToDatabase({
    required String nonce,
    required String brand,
    required String lastFourDigits,
    required int expirationMonth,
    required int expirationYear,
    required String postalCode,
    required bool isGiftCard,
  }) async {
    CollectionReference collectionReference = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('squareCreditCards');
    var savedCard = await collectionReference
        .where('lastFourDigits', isEqualTo: lastFourDigits)
        .get();
    if (savedCard.docs.isEmpty) {
      var docID = collectionReference.doc().id;
      await removeOldDefaultPayment(collectionReference);
      await collectionReference.doc(docID).set({
        'uid': docID,
        'userID': uid,
        'nonce': nonce,
        'brand': brand,
        'lastFourDigits': lastFourDigits,
        'expirationMonth': expirationMonth,
        'expirationYear': expirationYear,
        'postalCode': postalCode,
        'defaultPayment': true,
        'isGiftCard': isGiftCard,
        'cardNickname': isGiftCard == true ? 'jüs card' : firstName,
      });
    } else {
      return;
    }
  }

  removeOldDefaultPayment(CollectionReference collectionReference) async {
    QuerySnapshot oldDefaultPayment = await collectionReference
        .where('defaultPayment', isEqualTo: true)
        .get();
    for (var doc in oldDefaultPayment.docs) {
      await doc.reference.update({
        'defaultPayment': false,
      });
    }
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

  mapPaymentItems(List<PaymentsModel> cards, int index) {
    return {
      'uid': cards[index].uid,
      'userID': cards[index].userID,
      'nonce': cards[index].nonce,
      'brand': cards[index].brand,
      'isGiftCard': cards[index].isGiftCard,
      'lastFourDigits': cards[index].lastFourDigits,
      'expirationMonth': cards[index].expirationMonth,
      'expirationYear': cards[index].expirationYear,
      'defaultPayment': cards[index].defaultPayment,
      'cardNickname': cards[index].cardNickname,
      'postalCode': cards[index].postalCode,
    };
  }

  initSquarePayment() {
    setApplicationID();
    if (Platform.isIOS) {
      PaymentsServices().setIOSCardEntryTheme();
    }
    enterCreditCard();
  }

  initSquareGiftCardPayment() {
    setApplicationID();
    if (Platform.isIOS) {
      PaymentsServices().setIOSCardEntryTheme();
    }
    enterGiftCard();
  }

  Future setApplicationID() async {
    await InAppPayments.setSquareApplicationId('sq0idp-sTnvNvgfZ8wGZr9x7uxsmA');
  }

  enterCreditCard() async {
    await InAppPayments.startCardEntryFlow(
        onCardNonceRequestSuccess: (CardDetails result) {
          _onCardEntryCardNonceRequestSuccess(
              result: result, isGiftCard: false);
        },
        onCardEntryCancel: () {});
  }

  Future enterGiftCard() async {
    await InAppPayments.startGiftCardEntryFlow(
        onCardNonceRequestSuccess: (CardDetails result) {
          _onCardEntryCardNonceRequestSuccess(result: result, isGiftCard: true);
        },
        onCardEntryCancel: () {});
  }

  void _onCardEntryCardNonceRequestSuccess({
    required CardDetails result,
    required bool isGiftCard,
  }) async {
    if (uid != null) {
      addPaymentCardToDatabase(
        nonce: result.nonce,
        brand: result.card.brand.toString(),
        lastFourDigits: result.card.lastFourDigits,
        expirationMonth: result.card.expirationMonth,
        expirationYear: result.card.expirationYear,
        postalCode: result.card.postalCode!,
        isGiftCard: isGiftCard,
      );
    }
    try {
      await InAppPayments.completeCardEntry(onCardEntryComplete: () {
        ref!.read(guestCreditCardNonceProvider.notifier).add(result.nonce,
            result.card.lastFourDigits, result.card.brand.toString());
        Navigator.pop(context!);
      });
    } on Exception catch (ex) {
      InAppPayments.showCardNonceProcessingError(ex.toString());
    }
  }

  Future chargeCard(BuildContext context) async {
    Navigator.pop(context);
    Navigator.pop(context);

    return ModalBottomSheet().fullScreen(
      context: context,
      builder: (context) => const OrderConfirmationSheet(),
    );
  }

  Future setIOSCardEntryTheme() async {
    var themeConfigurationBuilder = IOSThemeBuilder();
    themeConfigurationBuilder.saveButtonTitle = 'Add Card';

    themeConfigurationBuilder.tintColor = RGBAColorBuilder()
      ..r = 0
      ..g = 0
      ..b = 0
      ..a = 1;
    themeConfigurationBuilder.keyboardAppearance = KeyboardAppearance.light;

    await InAppPayments.setIOSCardEntryTheme(themeConfigurationBuilder.build());
  }

  updateCardNickname(String cardID) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('squareCreditCards')
        .doc(cardID)
        .update({'cardNickname': ref!.watch(cardNicknameProvider)});
  }

  updateDefaultPayment(String cardID) async {
    CollectionReference collectionReference = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('squareCreditCards');
    await removeOldDefaultPayment(collectionReference);
    await collectionReference.doc(cardID).update({'defaultPayment': true});
  }
}
