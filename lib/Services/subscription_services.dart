import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:jus_mobile_order_app/Models/square_subscription_model.dart';
import 'package:jus_mobile_order_app/Models/subscription_invoice_model.dart';
import 'package:jus_mobile_order_app/Models/subscription_model.dart';

class SubscriptionServices {
  String? uid;

  SubscriptionServices({this.uid});

  final CollectionReference subscriptionCollection =
      FirebaseFirestore.instance.collection('subscriptions');

  Stream<SubscriptionModel> get subscriptionData {
    return subscriptionCollection
        .where('userId', isEqualTo: uid)
        .snapshots()
        .map(getSubscriptionDataFromDatabase);
  }

  SubscriptionModel getSubscriptionDataFromDatabase(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      final dynamic data = doc.data();
      return SubscriptionModel(
        userId: data['userId'],
        subscriptionId: data['subscriptionId'],
        cardId: data['cardId'],
        totalSaved: data['totalSaved'] ?? 0,
        bonusPoints: data['bonusPoints'] ?? 0,
      );
    }).first;
  }

  Future isRegisteringUserLegacyMember({required email}) async {
    return await FirebaseFunctions.instance
        .httpsCallable('fetchWooSubscriptionData')
        .call({
      'email': email,
    });
  }

  Future migrateLegacyWooCommerceSubscription({
    required firstName,
    required lastName,
    required email,
    required phone,
    required membershipId,
    required billingPeriod,
    required startDate,
    required nonce,
  }) async {
    HttpsCallableResult result = await FirebaseFunctions.instance
        .httpsCallable('migrateLegacyWooCommerceSubscription')
        .call({
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phone': phone,
      'membershipId': membershipId,
      'billingPeriod': billingPeriod,
      'startDate': startDate,
      'nonce': nonce,
    });

    // Extract the data from the HttpsCallableResult and cast it to a Map
    return result.data as Map;
  }

  static void createSubscription({
    required Map<String, dynamic> orderDetails,
    required VoidCallback onPaymentSuccess,
    required Function(String) onError,
  }) async {
    final result = await FirebaseFunctions.instance
        .httpsCallable('createSubscription')
        .call(orderDetails);

    if (result.data['status'] == 200) {
      onPaymentSuccess();
    } else {
      onError(result.data['message'] ??
          'There was an error processing this order. Please try again later.');
    }
  }

  Future<SquareSubscriptionModel> getSubscriptionFromApi(
      String subscriptionId) async {
    try {
      final result = await FirebaseFunctions.instance
          .httpsCallable('getSubscription')
          .call({'subscriptionId': subscriptionId});

      final subscriptionData = result.data['subscription'];

      return SquareSubscriptionModel(
        subscriptionId: subscriptionData['id'] ?? '',
        status: subscriptionData['status'] ?? '',
        startDate: subscriptionData['start_date'] ?? '',
        chargeThruDate: subscriptionData['charged_through_date'] ?? '',
        canceledDate: subscriptionData['canceled_date'] ?? '',
        monthlyBillingAnchorDate:
            subscriptionData['monthly_billing_anchor_date'] ?? 0,
      );
    } catch (e) {
      throw Exception('Failed to get subscription');
    }
  }

  Future<int> updateSubscriptionPaymentMethodCloudFunction({
    required String squareCustomerId,
    required String nonce,
  }) async {
    if (nonce.isEmpty || squareCustomerId.isEmpty) {
      return Future.error(
          'There was a problem updating your subscription. Please try again later.');
    }
    try {
      await FirebaseFunctions.instance
          .httpsCallable('updateSubscriptionPaymentMethod')
          .call({'squareCustomerId': squareCustomerId, 'nonce': nonce});
      return 200;
    } catch (e) {
      throw Exception('Failed to get subscription');
    }
  }

  Future resumeSquareSubscriptionCloudFunction() async {
    try {
      HttpsCallableResult result = await FirebaseFunctions.instance
          .httpsCallable('resumeSubscription')
          .call();

      // Extract the data from the HttpsCallableResult and cast it to a Map
      return result.data as Map;
    } catch (e) {
      throw e.toString();
    }
  }

  Future cancelSquareSubscriptionCloudFunction() async {
    HttpsCallableResult result = await FirebaseFunctions.instance
        .httpsCallable('cancelSubscription')
        .call();

    // Extract the data from the HttpsCallableResult and cast it to a Map
    return result.data as Map;
  }

  Future undoCancelSquareSubscriptionCloudFunction() async {
    try {
      await FirebaseFunctions.instance
          .httpsCallable('undoCancelSubscription')
          .call();
    } catch (e) {
      throw (e.toString());
    }

    return 200;
  }

  Future<List<SubscriptionInvoiceModel>> getSubscriptionInvoices(
      String squareCustomerId) async {
    try {
      HttpsCallableResult result = await FirebaseFunctions.instance
          .httpsCallable('getSquareInvoices')
          .call({
        'customerId': squareCustomerId,
      });
      List invoiceData = result.data as List;

      List<SubscriptionInvoiceModel> invoices = invoiceData
          .map(
            (doc) => SubscriptionInvoiceModel(
              price: doc['priceCharged'],
              itemName: doc['itemName'],
              paymentDate: doc['paymentDate'],
            ),
          )
          .toList();
      return invoices;
    } catch (e) {
      throw e.toString();
    }
  }
}
