import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Models/payments_model.dart';
import 'package:jus_mobile_order_app/Models/wallet_activities_model.dart';
import 'package:jus_mobile_order_app/Providers/payments_providers.dart';

class PaymentMethodDatabaseServices {
  final WidgetRef? ref;
  final String? userId;

  PaymentMethodDatabaseServices({this.ref, this.userId});

  Stream<List<PaymentsModel>> get squareCreditCards {
    CollectionReference collectionReference = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('squarePaymentMethods');
    return collectionReference
        .where('isWallet', isNotEqualTo: true)
        .snapshots()
        .map(getPaymentCardsListFromDatabase);
  }

  Stream<List<PaymentsModel>> get wallets {
    CollectionReference collectionReference = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('squarePaymentMethods');
    return collectionReference
        .where('isWallet', isEqualTo: true)
        .snapshots()
        .map(getPaymentCardsListFromDatabase);
  }

  Stream<PaymentsModel> get defaultPaymentCard {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
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
        .where('userDetails.userId', isEqualTo: userId)
        .orderBy('paymentDetails.createdAt', descending: true)
        .snapshots()
        .map(getWalletActivitiesFromDatabase);
  }

  PaymentsModel getDefaultCardFromDatabase(QuerySnapshot snapshot) {
    return snapshot.docs.map(
      (doc) {
        final dynamic data = doc.data();

        return PaymentsModel(
          uid: data['uid'] ?? '',
          userId: data['userId'] ?? '',
          cardId: data['cardId'] ?? '',
          brand: data['brand'] ?? '',
          isWallet: data['isWallet'],
          last4: data['last4'],
          expirationMonth: data['expirationMonth'] ?? '',
          expirationYear: data['expirationMonth'] ?? '',
          defaultPayment: data['defaultPayment'],
          cardNickname: data['cardNickname'],
          gan: data['gan'] ?? '',
          balance: data['balance'] ?? 0,
        );
      },
    ).first;
  }

  Future<PaymentsModel> getCardDetailsFromSquareCardId(
      String userId, String cardId) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('squarePaymentMethods')
        .where('cardId', isEqualTo: cardId)
        .get()
        .then((querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        return _getPaymentCardFromDocument(querySnapshot.docs.first, userId);
      }
      throw Exception('Card not found');
    });
  }

  PaymentsModel _getPaymentCardFromDocument(
      DocumentSnapshot doc, String userId) {
    final data = doc.data() as Map<String, dynamic>;
    return PaymentsModel(
      uid: data['uid'] ?? '',
      userId: data['userId'] ?? '',
      cardId: data['cardId'] ?? '',
      brand: data['brand'] ?? '',
      isWallet: data['isWallet'],
      last4: data['last4'],
      expirationMonth: data['expirationMonth'] ?? '',
      expirationYear: data['expirationYear'] ?? '',
      defaultPayment: data['defaultPayment'],
      cardNickname: data['cardNickname'],
      gan: data['gan'] ?? '',
      balance: data['balance'] ?? 0,
    );
  }

  List<PaymentsModel> getPaymentCardsListFromDatabase(QuerySnapshot snapshot) {
    return snapshot.docs.map(
      (doc) {
        final dynamic data = doc.data();
        return PaymentsModel(
          uid: data['uid'] ?? '',
          userId: userId ?? '',
          cardId: data['cardId'] ?? '',
          brand: data['brand'] ?? '',
          isWallet: data['isWallet'],
          last4: data['last4'],
          expirationMonth: data['expirationMonth'] ?? '',
          expirationYear: data['expirationYear'] ?? '',
          defaultPayment: data['defaultPayment'],
          cardNickname: data['cardNickname'],
          gan: data['gan'] ?? '',
          balance: data['balance'] ?? 0,
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
            userID: data['userDetails']['userId'] ?? '',
            orderNumber: data['orderDetails']['orderNumber'] ?? '',
            createdAt: data['paymentDetails']['createdAt'].toDate(),
            gan: data['paymentDetails']['gan'] ?? '',
            amount: data['paymentDetails']['amount'] ?? 0,
            activity: data['cardDetails']['activity']);
      },
    ).toList();
  }

  Future<dynamic> getCardIdFromNonce(
      String squareCustomerId, String nonce) async {
    final HttpsCallable callable =
        FirebaseFunctions.instance.httpsCallable('squareCreditCardIdFromNonce');
    try {
      var response = await callable.call({
        'squareCustomerId': squareCustomerId,
        'nonce': nonce,
      });
      return response.data;
    } catch (e) {
      return null;
    }
  }

  addPaymentCardToDatabase({
    required String cardId,
    required String brand,
    required String last4,
    required String expirationMonth,
    required String expirationYear,
    required bool isWallet,
    required String firstName,
  }) async {
    try {
      final HttpsCallable callable =
          FirebaseFunctions.instance.httpsCallable('addSavedPaymentToDatabase');
      await callable.call({
        'cardId': cardId,
        'brand': brand,
        'last4': last4,
        'expirationMonth': expirationMonth,
        'expirationYear': expirationYear,
        'isWallet': isWallet,
        'gan': null,
        'balance': null,
        'firstName': firstName,
      });
    } catch (e) {
      rethrow;
    }
  }

  void updatePaymentMethod(
      {required SelectedPaymentMethodNotifier reference,
      String? cardNickname,
      required bool isWallet,
      String? cardId,
      String? gan,
      int? balance,
      required String last4,
      required String brand}) {
    reference.updateSelectedPaymentMethod(
      cardNickname: cardNickname,
      isWallet: isWallet,
      cardId: cardId,
      gan: gan,
      brand: brand,
      balance: balance,
      last4: last4,
    );
  }

  updateCardNickname(
      {required String cardNickname,
      required String cardID,
      required VoidCallback onSuccess,
      required Function(String) onError}) async {
    try {
      await FirebaseFunctions.instance
          .httpsCallable('updateCardNickname')
          .call({'cardID': cardID, 'cardNickname': cardNickname});
      onSuccess();
    } catch (e) {
      onError(e.toString());
    }
  }

  updateDefaultPayment({
    required String cardID,
    required Function(String) onError,
  }) async {
    try {
      await FirebaseFunctions.instance
          .httpsCallable('updateDefaultPayment')
          .call({'cardID': cardID});
    } catch (e) {
      onError(e.toString());
    }
  }

  deletePaymentMethod(
      {required String cardID, required Function(String) onError}) async {
    try {
      await FirebaseFunctions.instance
          .httpsCallable('deletePaymentMethod')
          .call({'cardID': cardID});
    } catch (e) {
      onError(e.toString());
    }
  }
}
