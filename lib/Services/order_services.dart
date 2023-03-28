import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jus_mobile_order_app/Models/order_model.dart';

class OrderServices {
  final String userID;

  OrderServices({required this.userID});
  final CollectionReference ordersCollection =
      FirebaseFirestore.instance.collection('orders');

  Stream<List<OrderModel>> get orders {
    return ordersCollection
        .where(
          'createdAt',
          isLessThan: DateTime.now().add(
            const Duration(days: 120),
          ),
        )
        .where('userID', isEqualTo: userID)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(getOrdersFromDatabase);
  }

  List<OrderModel> getOrdersFromDatabase(QuerySnapshot snapshot) {
    return snapshot.docs.map(
      (doc) {
        final dynamic data = doc.data();

        return OrderModel(
          userID: data['userID'],
          orderNumber: data['orderNumber'],
          locationID: data['locationID'],
          createdAt: data['createdAt'].toDate(),
          items: data['items'],
          paymentMethod: data['paymentMethod'],
          paymentSource: data['paymentSource'],
          cardBrand: data['cardBrand'],
          lastFourDigits: data['lastFourDigits'],
          totalAmount: data['totalAmount'],
          originalSubtotalAmount: data['originalSubtotalAmount'] ?? 0,
          discountedSubtotalAmount: data['discountedSubtotalAmount'] ?? 0,
          taxAmount: data['taxAmount'],
          tipAmount: data['tipAmount'],
          discountAmount: data['discountAmount'],
          pointsEarned: data['pointsEarned'],
          pointsRedeemed: data['pointsRedeemed'],
        );
      },
    ).toList();
  }
}
