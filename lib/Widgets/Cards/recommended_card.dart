import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/products.dart';
import 'package:jus_mobile_order_app/Providers/ProviderWidgets/recommended_products_provider_widget.dart';
import 'package:jus_mobile_order_app/Widgets/Cards/menu_card_small.dart';

class RecommendedCard extends ConsumerWidget {
  final int index;

  const RecommendedCard({required this.index, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return RecommendedProductsProviderWidget(
      builder: (recommended) => MenuCardSmall(
        product: recommended[index],
        providerFunction: () =>
            ProductHelpers(ref: ref).setProductProviders(recommended[index]),
      ),
    );
  }
}
