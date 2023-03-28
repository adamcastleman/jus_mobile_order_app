import 'package:animations/animations.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/formulas.dart';
import 'package:jus_mobile_order_app/Helpers/locations.dart';
import 'package:jus_mobile_order_app/Helpers/set_standard_ingredients.dart';
import 'package:jus_mobile_order_app/Helpers/set_standard_items.dart';
import 'package:jus_mobile_order_app/Helpers/spacing_widgets.dart';
import 'package:jus_mobile_order_app/Providers/ProviderWidgets/favorites_provider_widget.dart';
import 'package:jus_mobile_order_app/Providers/ProviderWidgets/ingredients_provider_widget.dart';
import 'package:jus_mobile_order_app/Providers/ProviderWidgets/products_provider_widget.dart';
import 'package:jus_mobile_order_app/Providers/location_providers.dart';
import 'package:jus_mobile_order_app/Providers/product_providers.dart';
import 'package:jus_mobile_order_app/Views/product_detail_page.dart';

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
            return OpenContainer(
              openElevation: 0,
              closedElevation: 0,
              closedShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              tappable: false,
              transitionDuration: const Duration(milliseconds: 600),
              openBuilder: (context, open) {
                return ProductDetailPage(
                  product: currentProduct,
                );
              },
              closedBuilder: (context, close) {
                return InkWell(
                  onTap: () {
                    if (ref.read(selectedLocationProvider) == null) {
                      LocationHelper().chooseLocation(context, ref);
                      null;
                    } else {
                      ref.read(selectedProductIDProvider.notifier).state =
                          currentProduct.productID;
                      ref.read(isScheduledProvider.notifier).state =
                          currentProduct.isScheduled;
                      currentProduct.isScheduled
                          ? StandardItems(ref: ref).set(currentProduct)
                          : StandardIngredients(ref: ref).set(currentProduct);
                      ref
                          .read(selectedIngredientsProvider.notifier)
                          .addIngredients(favorites[index].ingredients);
                      ref
                          .read(selectedToppingsProvider.notifier)
                          .addMultipleToppings(favorites[index].toppings);
                      ref.read(itemKeyProvider.notifier).state =
                          Formulas().idGenerator();
                      ref.read(itemSizeProvider.notifier).state =
                          favorites[index].size;
                      ref
                          .read(selectedAllergiesProvider.notifier)
                          .addListOfAllergies(favorites[index].allergies);
                      close();
                    }
                  },
                  child: SizedBox(
                    width: 150,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 12.0, horizontal: 12.0),
                      child: Column(
                        children: [
                          Hero(
                            tag: 'product-image',
                            child: SizedBox(
                              height: 130,
                              width: 100,
                              child: CachedNetworkImage(
                                imageUrl: currentProduct.image,
                              ),
                            ),
                          ),
                          Spacing().vertical(15),
                          AutoSizeText(
                            favorites[index].name,
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                            maxLines: 2,
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
