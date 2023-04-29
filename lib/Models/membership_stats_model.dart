import 'package:freezed_annotation/freezed_annotation.dart';

part 'membership_stats_model.freezed.dart';

@freezed
class MembershipStatsModel with _$MembershipStatsModel {
  const factory MembershipStatsModel({
    int? totalSaved,
    int? bonusPoints,
  }) = _MembershipStatsModel;
}
