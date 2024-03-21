import 'package:freezed_annotation/freezed_annotation.dart';

part 'product_model.freezed.dart';

@freezed
class ProductModel with _$ProductModel {
  const factory ProductModel({
    required String uid,
    required String name,
    required String category,
    required int categoryOrder,
    required String productId,
    required String description,
    required List ingredients,
    required String image,
    required bool isActive,
    required List variations,
    required bool taxable,
    required bool isNew,
    required bool isRecommended,
    required bool isFeatured,
    required bool isModifiable,
    required bool isScheduled,
    required bool hasToppings,
    required List nutrition,
    required String perks,
    required int servingsFruit,
    required int servingsVeggie,
    int? scheduledProductLimit,
    String? scheduledProductType,
  }) = _ProductModel;
}

@freezed
class ProductQuantityModel with _$ProductQuantityModel {
  const factory ProductQuantityModel({
    required String uid,
    required String locationId,
    required String productType,
    required int hoursNotice,
    int? quantityLimit,
    int? scheduledQuantityLimit,
    String? scheduledProductDescriptor,
    String? toppingsDescriptor,
    int? toppingsQuantityLimit,
  }) = _ProductQuantityModel;
}

@freezed
class QuantityLimitParams with _$QuantityLimitParams {
  const factory QuantityLimitParams({
    required String productUID,
    required String locationId,
  }) = _QuantityLimitParams;
}
