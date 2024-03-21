import 'package:freezed_annotation/freezed_annotation.dart';

part 'square_subscription_model.freezed.dart';
part 'square_subscription_model.g.dart';

@freezed
class SquareSubscriptionModel with _$SquareSubscriptionModel {
  const factory SquareSubscriptionModel({
    required String subscriptionId,
    required String startDate,
    String? canceledDate,
    int? monthlyBillingAnchorDate,
  }) = _SquareSubscriptionModel;

  factory SquareSubscriptionModel.fromJson(Map<String, Object?> json) =>
      _$SquareSubscriptionModelFromJson(json);
}
