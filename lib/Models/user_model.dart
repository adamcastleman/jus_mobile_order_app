import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_model.freezed.dart';

@freezed
class UserModel with _$UserModel {
  const factory UserModel({
    String? uid,
    String? firstName,
    String? lastName,
    String? email,
    String? phone,
    bool? isActiveMember,
    int? totalPoints,
  }) = _UserModel;
}
