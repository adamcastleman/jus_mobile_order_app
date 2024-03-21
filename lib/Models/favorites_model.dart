import 'package:freezed_annotation/freezed_annotation.dart';

part 'favorites_model.freezed.dart';

@freezed
class FavoritesModel with _$FavoritesModel {
  const factory FavoritesModel({
    required String uid,
    required String name,
    required List ingredients,
    required List toppings,
    required String productId,
    required int size,
    required List allergies,
  }) = _FavoritesModel;
}
