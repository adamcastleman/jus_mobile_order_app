import 'package:freezed_annotation/freezed_annotation.dart';

part 'points_details_model.freezed.dart';

@freezed
class PointsDetailsModel with _$PointsDetailsModel {
  const factory PointsDetailsModel({
    required String uid,
    required List perks,
    required List rewardsAmounts,
    required String name,
    required int pointsPerDollar,
    required int memberPointsPerDollar,
    required String pointsStatus,
    required String memberPointsStatus,
  }) = _PointsDetailsModel;
}
