import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jus_mobile_order_app/Models/order_model.dart';

class OrderServices {
  final String userID;

  OrderServices({required this.userID});
  final CollectionReference ordersCollection =
      FirebaseFirestore.instance.collection('orders');

  Stream<List<OrderModel>> get orders {
    return ordersCollection
        .where('createdAt',
            isLessThan: DateTime.now().add(const Duration(days: 120)))
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
          uid: data['uid'],
          userID: data['userID'],
          orderID: data['orderID'],
          locationID: data['locationID'],
          createdAt: data['createAt'].toDate(),
          pickupTime: data['pickupTime'].toDate(),
          pickupDate: data['pickupDate'].toDate(),
          scheduleAllItems: data['scheduleAllItems'],
          items: data['items'],
          paymentID: data['paymentID'],
          paymentMethod: data['paymentMethod'],
          orderStatus: data['orderStatus'],
          paymentStatus: data['paymentStatus'],
          cardBrand: data['cardBrand'],
          lastFourDigits: data['lastFourDigits'],
          totalAmount: data['totalAmount'],
          subtotalAmount: data['subtotalAmount'],
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
