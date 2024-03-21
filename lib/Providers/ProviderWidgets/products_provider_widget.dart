import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/error.dart';
import 'package:jus_mobile_order_app/Helpers/loading.dart';
import 'package:jus_mobile_order_app/Models/product_model.dart';
import 'package:jus_mobile_order_app/Providers/stream_providers.dart';

class ProductsProviderWidget extends ConsumerWidget {
  final Widget Function(List<ProductModel> products) builder;
  final dynamic loading;
  final dynamic error;
  const ProductsProviderWidget(
      {required this.builder, this.loading, this.error, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final products = ref.watch(productsProvider);
    return products.when(
      error: (e, _) =>
          error ??
          ShowError(
            error: e.toString(),
          ),
      loading: () =>
          loading ??
          Container(
            height: double.infinity,
            width: double.infinity,
            color: Colors.white,
            child: const Loading(),
          ),
      data: (products) => builder(products),
    );
  }
}
