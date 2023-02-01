import 'package:freezed_annotation/freezed_annotation.dart';

part 'location_model.freezed.dart';

@freezed
class LocationModel with _$LocationModel {
  const factory LocationModel({
    required String uid,
    required String name,
    required int locationID,
    required int phone,
    required Map address,
    required List hours,
    required String timezone,
    required double latitude,
    required double longitude,
    required bool isActive,
    required bool isAcceptingOrders,
    required double salesTaxRate,
    required bool acceptingOrders,
    required List unavailableProducts,
    required List unavailableIngredients,
    required bool comingSoon,
  }) = _LocationModel;
}
