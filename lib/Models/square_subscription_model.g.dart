// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'square_subscription_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SquareSubscriptionModelImpl _$$SquareSubscriptionModelImplFromJson(
        Map<String, dynamic> json) =>
    _$SquareSubscriptionModelImpl(
      subscriptionId: json['subscriptionId'] as String,
      startDate: json['startDate'] as String,
      canceledDate: json['canceledDate'] as String?,
      monthlyBillingAnchorDate: json['monthlyBillingAnchorDate'] as int?,
    );

Map<String, dynamic> _$$SquareSubscriptionModelImplToJson(
        _$SquareSubscriptionModelImpl instance) =>
    <String, dynamic>{
      'subscriptionId': instance.subscriptionId,
      'startDate': instance.startDate,
      'canceledDate': instance.canceledDate,
      'monthlyBillingAnchorDate': instance.monthlyBillingAnchorDate,
    };
