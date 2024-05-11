import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/loading.dart';
import 'package:jus_mobile_order_app/Models/product_model.dart';
import 'package:jus_mobile_order_app/Providers/location_providers.dart';
import 'package:jus_mobile_order_app/Providers/stream_providers.dart';
import 'package:jus_mobile_order_app/Widgets/Icons/error_icon.dart';

class ProductQuantityLimitProviderWidget extends ConsumerWidget {
  final String productUID;
  final String? locationId;
  final Widget Function(ProductQuantityModel quantityLimits) builder;
  final dynamic loading;
  final dynamic error;
  const ProductQuantityLimitProviderWidget(
      {required this.builder,
      required this.productUID,
      this.locationId,
      this.loading,
      this.error,
      super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedLocation = ref.watch(selectedLocationProvider);
    final params = QuantityLimitParams(
        productUID: productUID,
        locationId: locationId == null && selectedLocation.uid.isEmpty
            ? '1'
            : locationId ?? selectedLocation.locationId);

    final quantityLimits = ref.watch(
      productQuantityLimitProvider(params),
    );
    return quantityLimits.when(
        error: (e, _) => error ?? const ErrorIcon(),
        loading: () => loading ?? const Loading(),
        data: (quantityLimits) {
          return builder(quantityLimits);
        });
  }
}
