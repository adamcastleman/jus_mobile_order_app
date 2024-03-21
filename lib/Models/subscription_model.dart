import 'package:freezed_annotation/freezed_annotation.dart';

part 'subscription_model.freezed.dart';

@freezed
class SubscriptionModel with _$SubscriptionModel {
  const factory SubscriptionModel({
    required String userId,
    required String subscriptionId,
    required String cardId,
    int? bonusPoints,
    int? totalSaved,
  }) = _SubscriptionModel;
}
