import 'package:freezed_annotation/freezed_annotation.dart';

part 'payments_model.freezed.dart';

@freezed
class PaymentsModel with _$PaymentsModel {
  const factory PaymentsModel({
    required String uid,
    required String userID,
    required String nonce,
    required String brand,
    required String lastFourDigits,
    required int expirationMonth,
    required int expirationYear,
    required bool defaultPayment,
    required String cardNickname,
    required bool isGiftCard,
    String? postalCode,
  }) = _PaymentsModel;
}
