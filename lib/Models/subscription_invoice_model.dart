import 'package:freezed_annotation/freezed_annotation.dart';

part 'subscription_invoice_model.freezed.dart';

@freezed
class SubscriptionInvoiceModel with _$SubscriptionInvoiceModel {
  const factory SubscriptionInvoiceModel({
    required int price,
    required String itemName,
    required String paymentDate,
  }) = _SubscriptionInvoiceModel;
}
