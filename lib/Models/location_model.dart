import 'package:freezed_annotation/freezed_annotation.dart';

part 'location_model.freezed.dart';

@freezed
class LocationModel with _$LocationModel {
  const factory LocationModel({
    required String uid,
    required String name,
    required String status,
    required int locationID,
    required String squareLocationId,
    required int phone,
    required Map address,
    required List hours,
    required String timezone,
    required String currency,
    required String geohash,
    required double latitude,
    required double longitude,
    required bool isActive,
    required bool isAcceptingOrders,
    required double salesTaxRate,
    required bool acceptingOrders,
    required List unavailableProducts,
    required List blackoutDates,
  }) = _LocationModel;
}
