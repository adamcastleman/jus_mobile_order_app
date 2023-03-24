import 'package:freezed_annotation/freezed_annotation.dart';

part 'order_model.freezed.dart';

@freezed
class OrderModel with _$OrderModel {
  const factory OrderModel({
    required String uid,
    String? userID,
    required String orderID,
    required int locationID,
    required DateTime createdAt,
    DateTime? pickupTime,
    DateTime? pickupDate,
    required bool scheduleAllItems,
    required List items,
    required String orderStatus,
    required String paymentStatus,
    required String paymentID,
    required String paymentMethod,
    String? cardBrand,
    String? lastFourDigits,
    required int totalAmount,
    required int subtotalAmount,
    required int taxAmount,
    required int discountAmount,
    required int tipAmount,
    required int pointsEarned,
    required int pointsRedeemed,
  }) = _OrderModel;
}
