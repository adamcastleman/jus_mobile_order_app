import 'package:freezed_annotation/freezed_annotation.dart';

part 'wallet_activities_model.freezed.dart';

@freezed
class WalletActivitiesModel with _$WalletActivitiesModel {
  const factory WalletActivitiesModel({
    required String userID,
    required String orderNumber,
    required DateTime createdAt,
    required String gan,
    required int amount,
  }) = _WalletActivitiesModel;
}
