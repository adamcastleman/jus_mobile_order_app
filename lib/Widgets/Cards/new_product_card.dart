import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/products.dart';
import 'package:jus_mobile_order_app/Providers/ProviderWidgets/new_products_provider_widget.dart';
import 'package:jus_mobile_order_app/Widgets/Cards/menu_card_small.dart';

class NewProductCard extends ConsumerWidget {
  final int index;

  const NewProductCard({required this.index, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return NewProductsProviderWidget(
      builder: (products) => MenuCardSmall(
        product: products[index],
        providerFunction: () =>
            ProductHelpers(ref: ref).setProductProviders(products[index]),
      ),
    );
  }
}
