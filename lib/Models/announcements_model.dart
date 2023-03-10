import 'package:freezed_annotation/freezed_annotation.dart';

part 'announcements_model.freezed.dart';

@freezed
class AnnouncementsModel with _$AnnouncementsModel {
  const factory AnnouncementsModel({
    required String uid,
    required String title,
    required String description,
    required bool isActive,
  }) = _AnnouncementsModel;
}
