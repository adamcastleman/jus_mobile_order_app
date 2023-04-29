import 'package:freezed_annotation/freezed_annotation.dart';

part 'offers_model.freezed.dart';

@freezed
class OffersModel with _$OffersModel {
  const factory OffersModel({
    required String uid,
    required String name,
    required String description,
    required int itemLimit,
    required int discount,
    required double pointsMultiple,
    required List qualifyingProducts,
    required bool isMemberOnly,
    required bool isActive,
  }) = _OffersModel;
}
