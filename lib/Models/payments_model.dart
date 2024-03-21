import 'package:freezed_annotation/freezed_annotation.dart';

part 'payments_model.freezed.dart';

@freezed
class PaymentsModel with _$PaymentsModel {
  const factory PaymentsModel({
    required String userId,
    required String brand,
    required String last4,
    required bool defaultPayment,
    required String cardNickname,
    required bool isWallet,
    String? uid,
    String? cardId,
    String? expirationMonth,
    String? expirationYear,
    String? gan,
    int? balance,
  }) = _PaymentsModel;
}
