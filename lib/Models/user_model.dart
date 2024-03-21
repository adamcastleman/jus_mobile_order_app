import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:jus_mobile_order_app/Helpers/enums.dart';

part 'user_model.freezed.dart';

@freezed
class UserModel with _$UserModel {
  const factory UserModel({
    String? uid,
    String? firstName,
    String? lastName,
    String? email,
    String? phone,
    SubscriptionStatus? subscriptionStatus,
    String? squareCustomerId,
    int? points,
  }) = _UserModel;
}
