import 'package:freezed_annotation/freezed_annotation.dart';

part 'product_model.freezed.dart';

@freezed
class ProductModel with _$ProductModel {
  const factory ProductModel({
    required String uid,
    required String name,
    required String category,
    required int categoryOrder,
    required int productID,
    required String description,
    required List ingredients,
    required String image,
    required bool isActive,
    required List memberPrice,
    required List price,
    required bool taxable,
    required bool isNew,
    required bool isRecommended,
    required bool isFeatured,
    required bool isModifiable,
    required bool isScheduled,
    required int hoursNotice,
    required bool hasToppings,
    required List nutrition,
    required String perks,
    required int servingsFruit,
    required int servingsVeggie,
  }) = _ProductModel;
}
