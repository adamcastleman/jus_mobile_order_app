import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/error.dart';
import 'package:jus_mobile_order_app/Helpers/loading.dart';
import 'package:jus_mobile_order_app/Models/product_model.dart';
import 'package:jus_mobile_order_app/Providers/location_providers.dart';
import 'package:jus_mobile_order_app/Providers/stream_providers.dart';

class ProductQuantityLimitProviderWidget extends ConsumerWidget {
  final String productUID;
  final int? locationID;
  final Widget Function(ProductQuantityModel quantityLimits) builder;
  final dynamic loading;
  final dynamic error;
  const ProductQuantityLimitProviderWidget(
      {required this.builder,
      required this.productUID,
      this.locationID,
      this.loading,
      this.error,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedLocation = ref.watch(selectedLocationProvider);

    final params = QuantityLimitParams(
        productUID: productUID,
        locationID: locationID == null && selectedLocation == null
            ? 1
            : locationID ?? selectedLocation.locationID);
    final quantityLimits = ref.watch(
      productQuantityLimitProvider(params),
    );
    return quantityLimits.when(
        error: (e, _) =>
            error ??
            ShowError(
              error: e.toString(),
            ),
        loading: () => loading ?? const Loading(),
        data: (quantityLimits) {
          return builder(quantityLimits);
        });
  }
}
