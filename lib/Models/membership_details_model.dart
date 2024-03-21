import 'package:freezed_annotation/freezed_annotation.dart';

part 'membership_details_model.freezed.dart';

@freezed
class MembershipDetailsModel with _$MembershipDetailsModel {
  const factory MembershipDetailsModel({
    required String uid,
    required List perks,
    required List subscriptionPrice,
    required String description,
    required String signUpText,
    required String name,
    required String termsOfService,
  }) = _MembershipDetailsModel;
}
