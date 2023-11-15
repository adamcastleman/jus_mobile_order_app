import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/modal_bottom_sheets.dart';
import 'package:jus_mobile_order_app/Helpers/payments.dart';
import 'package:jus_mobile_order_app/Models/payments_model.dart';
import 'package:jus_mobile_order_app/Models/wallet_activities_model.dart';
import 'package:jus_mobile_order_app/Providers/payments_providers.dart';
import 'package:jus_mobile_order_app/Sheets/invalid_sheet_single_pop.dart';

class PaymentMethodsServices {
  final WidgetRef? ref;
  final String? userID;

  PaymentMethodsServices({this.ref, this.userID});

  Stream<List<PaymentsModel>> get squareCreditCards {
    CollectionReference collectionReference = FirebaseFirestore.instance
        .collection('users')
        .doc(userID)
        .collection('squarePaymentMethods');
    return collectionReference
        .where('isWallet', isNotEqualTo: true)
        .snapshots()
        .map(getPaymentCardsFromDatabase);
  }

  Stream<List<PaymentsModel>> get wallets {
    CollectionReference collectionReference = FirebaseFirestore.instance
        .collection('users')
        .doc(userID)
        .collection('squarePaymentMethods');
    return collectionReference
        .where('isWallet', isEqualTo: true)
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

  Stream<List<WalletActivitiesModel>> get walletActivities {
    return FirebaseFirestore.instance
        .collection('walletActivities')
        .where(
          'paymentDetails.createdAt',
          isLessThan: DateTime.now().add(
            const Duration(days: 120),
          ),
        )
        .where('userDetails.userID', isEqualTo: userID)
        .orderBy('paymentDetails.createdAt', descending: true)
        .snapshots()
        .map(getWalletActivitiesFromDatabase);
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
          lastFourDigits: data['lastFourDigits'],
          expirationMonth: data['expirationMonth'],
          expirationYear: data['expirationYear'],
          isWallet: data['isWallet'],
          defaultPayment: data['defaultPayment'],
          cardNickname: data['cardNickname'],
          gan: data['gan'],
          balance: data['balance'],
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
          isWallet: data['isWallet'],
          lastFourDigits: data['lastFourDigits'],
          expirationMonth: data['expirationMonth'],
          expirationYear: data['expirationYear'],
          defaultPayment: data['defaultPayment'],
          cardNickname: data['cardNickname'],
          gan: data['gan'],
          balance: data['balance'],
        );
      },
    ).toList();
  }

  List<WalletActivitiesModel> getWalletActivitiesFromDatabase(
      QuerySnapshot snapshot) {
    return snapshot.docs
        .where((doc) =>
            (doc.data() as Map<String, dynamic>)['cardDetails']['activity'] !=
            'REDEEM')
        .map(
      (doc) {
        final dynamic data = doc.data();
        return WalletActivitiesModel(
            userID: data['userDetails']['userID'],
            orderNumber: data['orderDetails']['orderNumber'],
            createdAt: data['paymentDetails']['createdAt'].toDate(),
            gan: data['cardDetails']['gan'],
            amount: data['paymentDetails']['amount'],
            activity: data['cardDetails']['activity']);
      },
    ).toList();
  }

  addPaymentCardToDatabase({
    required String nonce,
    required String brand,
    required String lastFourDigits,
    required int expirationMonth,
    required int expirationYear,
    required bool isWallet,
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
        'isWallet': isWallet,
        'gan': null,
        'balance': null,
        'firstName': firstName,
      });
    } catch (e) {
      return;
      // Handle the error as needed
    }
  }

  void updatePaymentMethod(
      {required SelectedPaymentMethodNotifier reference,
      String? cardNickname,
      required bool isWallet,
      String? nonce,
      String? gan,
      int? balance,
      required String lastFourDigits,
      required String brand}) {
    reference.updateSelectedPaymentMethod(
        card: PaymentsHelper().setSelectedPaymentMap(
            cardNickname: cardNickname,
            isWallet: isWallet,
            nonce: nonce,
            gan: gan,
            brand: brand,
            balance: balance,
            lastFourDigits: lastFourDigits));
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
        builder: (context) => InvalidSheetSinglePop(
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
        builder: (context) => InvalidSheetSinglePop(
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
        builder: (context) => InvalidSheetSinglePop(
          error: e.toString(),
        ),
      );
    }
  }
}
