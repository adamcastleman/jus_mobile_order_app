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
          'paymentDetails.createdAt',
          isLessThan: DateTime.now().add(
            const Duration(days: 120),
          ),
        )
        .where('userDetails.userID', isEqualTo: userID)
        .orderBy('paymentDetails.createdAt', descending: true)
        .snapshots()
        .map(getOrdersFromDatabase);
  }

  List<OrderModel> getOrdersFromDatabase(QuerySnapshot snapshot) {
    return snapshot.docs.map(
      (doc) {
        final dynamic data = doc.data();

        return OrderModel(
          userID: data['userDetails']['userID'],
          locationID: data['locationDetails']['locationID'],
          pointsEarned: data['pointsDetails']['pointsEarned'],
          pointsRedeemed: data['pointsDetails']['pointsRedeemed'],
          orderNumber: data['orderDetails']['orderNumber'],
          orderSource: data['orderDetails']['orderSource'],
          items: data['orderDetails']['items'],
          pickupDate: data['orderDetails']['pickupDate']?.toDate(),
          pickupTime: data['orderDetails']['pickupTime']?.toDate(),
          paymentMethod: data['paymentDetails']['paymentMethod'],
          createdAt: data['paymentDetails']['createdAt'].toDate(),
          cardBrand: data['paymentDetails']['cardBrand'],
          lastFourDigits: data['paymentDetails']['lastFourDigits'],
          totalAmount: data['totals']['totalAmount'],
          originalSubtotalAmount: data['totals']['originalSubtotalAmount'],
          discountedSubtotalAmount: data['totals']['discountedSubtotalAmount'],
          taxAmount: data['totals']['taxAmount'],
          tipAmount: data['totals']['tipAmount'],
          discountAmount: data['totals']['discountAmount'],
        );
      },
    ).toList();
  }
}
