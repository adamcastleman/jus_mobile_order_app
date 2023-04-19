import 'package:freezed_annotation/freezed_annotation.dart';

part 'payments_model.freezed.dart';

@freezed
class PaymentsModel with _$PaymentsModel {
  const factory PaymentsModel({
    required String uid,
    required String userID,
    required String brand,
    required String lastFourDigits,
    required bool defaultPayment,
    required String cardNickname,
    required bool isWallet,
    String? postalCode,
    int? expirationMonth,
    int? expirationYear,
    String? nonce,
    String? gan,
    int? balance,
  }) = _PaymentsModel;
}
