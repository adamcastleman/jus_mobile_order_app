import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/error.dart';
import 'package:jus_mobile_order_app/Helpers/loading.dart';
import 'package:jus_mobile_order_app/Models/product_model.dart';
import 'package:jus_mobile_order_app/Providers/stream_providers.dart';

class RecommendedProductsProviderWidget extends ConsumerWidget {
  final Widget Function(List<ProductModel> recommended) builder;
  final dynamic loading;
  final dynamic error;
  const RecommendedProductsProviderWidget(
      {required this.builder, this.loading, this.error, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final products = ref.watch(recommendedProductsProvider);
    return products.when(
      error: (e, _) =>
          error ??
          ShowError(
            error: e.toString(),
          ),
      loading: () => loading ?? const Loading(),
      data: (recommended) => builder(recommended),
    );
  }
}
