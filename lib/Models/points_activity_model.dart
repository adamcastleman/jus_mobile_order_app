import 'package:freezed_annotation/freezed_annotation.dart';

part 'points_activity_model.freezed.dart';

@freezed
class PointsActivityModel with _$PointsActivityModel {
  const factory PointsActivityModel({
    required String userId,
    int? pointsEarned,
    int? pointsRedeemed,
    int? timestamp,
  }) = _PointsActivityModel;
}
