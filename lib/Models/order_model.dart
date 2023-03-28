import 'package:freezed_annotation/freezed_annotation.dart';

part 'order_model.freezed.dart';

@freezed
class OrderModel with _$OrderModel {
  const factory OrderModel({
    String? userID,
    required String orderNumber,
    required int locationID,
    required DateTime createdAt,
    required List items,
    required String paymentMethod,
    required String paymentSource,
    String? cardBrand,
    String? lastFourDigits,
    required int totalAmount,
    required int originalSubtotalAmount,
    required int discountedSubtotalAmount,
    required int taxAmount,
    required int discountAmount,
    required int tipAmount,
    required int pointsEarned,
    required int pointsRedeemed,
  }) = _OrderModel;
}
