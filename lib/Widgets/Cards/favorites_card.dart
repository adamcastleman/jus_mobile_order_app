import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/products.dart';
import 'package:jus_mobile_order_app/Providers/ProviderWidgets/favorites_provider_widget.dart';
import 'package:jus_mobile_order_app/Providers/ProviderWidgets/ingredients_provider_widget.dart';
import 'package:jus_mobile_order_app/Providers/ProviderWidgets/products_provider_widget.dart';
import 'package:jus_mobile_order_app/Widgets/Cards/menu_card_small.dart';

class FavoritesCard extends ConsumerWidget {
  final int index;

  const FavoritesCard({required this.index, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IngredientsProviderWidget(
      builder: (ingredients) => ProductsProviderWidget(
        builder: (products) => FavoritesProviderWidget(
          builder: (favorites) {
            final currentProduct = products.firstWhere(
                (element) => element.productID == favorites[index].productID);
            return MenuCardSmall(
              product: currentProduct,
              favoriteName: favorites[index].name,
              providerFunction: () => ProductHelpers(ref: ref)
                  .setFavoritesProviders(currentProduct, favorites[index]),
            );
          },
        ),
      ),
    );
  }
}
