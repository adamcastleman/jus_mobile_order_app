import 'package:freezed_annotation/freezed_annotation.dart';

part 'ingredient_model.freezed.dart';

@freezed
class IngredientModel with _$IngredientModel {
  const factory IngredientModel({
    required String uid,
    required String name,
    required String image,
    required String category,
    required int id,
    required int price,
    required int memberPrice,
    required bool isModifiable,
    required bool isStandardTopping,
    required bool isBlended,
    required bool isTopping,
    required bool isExtraCharge,
    required bool containsDairy,
    required bool containsGluten,
  }) = _IngredientModel;
}
