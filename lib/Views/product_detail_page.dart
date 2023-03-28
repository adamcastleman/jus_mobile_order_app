import 'package:animations/animations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/loading.dart';
import 'package:jus_mobile_order_app/Helpers/set_standard_ingredients.dart';
import 'package:jus_mobile_order_app/Helpers/spacing_widgets.dart';
import 'package:jus_mobile_order_app/Models/product_model.dart';
import 'package:jus_mobile_order_app/Providers/product_providers.dart';
import 'package:jus_mobile_order_app/Providers/theme_providers.dart';
import 'package:jus_mobile_order_app/Views/product_modifier_page.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/close_button.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/favorite_button.dart';
import 'package:jus_mobile_order_app/Widgets/General/allergy_info.dart';
import 'package:jus_mobile_order_app/Widgets/General/item_price_display.dart';
import 'package:jus_mobile_order_app/Widgets/General/perks_info.dart';
import 'package:jus_mobile_order_app/Widgets/General/select_product_options.dart';
import 'package:jus_mobile_order_app/Widgets/General/size_selector.dart';
import 'package:jus_mobile_order_app/Widgets/Lists/select_toppings_grid_view.dart';
import 'package:jus_mobile_order_app/Widgets/Lists/unmodifiable_ingredient_grid.dart';

import '../Widgets/General/nutrition_facts.dart';

class ProductDetailPage extends ConsumerWidget {
  final ProductModel product;

  const ProductDetailPage({required this.product, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final backgroundColor = ref.watch(backgroundColorProvider);
    final editOrder = ref.watch(editOrderProvider);
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: editOrder != true
            ? FavoriteButton(product: product)
            : const SizedBox(),
        actions: [
          editOrder != true
              ? JusCloseButton(
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    Navigator.pop(context);
                    ref.invalidate(selectedIngredientsProvider);
                    ref.invalidate(selectedAllergiesProvider);
                    ref.invalidate(itemQuantityProvider);
                    ref.invalidate(scheduledQuantityProvider);
                    ref.invalidate(itemSizeProvider);
                    ref.invalidate(selectedProductIDProvider);
                    ref.invalidate(favoriteItemNameProvider);
                  },
                )
              : const SizedBox(),
        ],
      ),
      body: OpenContainer(
        tappable: false,
        openColor: backgroundColor,
        closedColor: backgroundColor,
        closedElevation: 2,
        openElevation: 2,
        transitionDuration: const Duration(milliseconds: 900),
        transitionType: ContainerTransitionType.fadeThrough,
        closedShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        openBuilder: (context, _) => SafeArea(
          bottom: false,
          child: ProductModifierPage(product: product),
        ),
        closedBuilder: (context, close) => Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.only(top: 60.0, left: 30, right: 30),
                primary: false,
                children: [
                  Center(
                    child: Hero(
                      tag: 'product-image',
                      child: SizedBox(
                        height: 300,
                        child: CachedNetworkImage(
                          fit: BoxFit.fitWidth,
                          imageUrl: product.image,
                          placeholder: (context, url) => const Loading(),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                        ),
                      ),
                    ),
                  ),
                  Spacing().vertical(40),
                  Text(
                    product.name,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  Spacing().vertical(20),
                  determineSizeSelector(),
                  PriceDisplay(product: product),
                  determineIngredientGrid(context, ref, close),
                  PerksInfo(product: product),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: NutritionFacts(
                      product: product,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: AllergyInfo(
                      product: product,
                    ),
                  ),
                ],
              ),
            ),
            SelectProductOptions(
              product: product,
              close: close,
            ),
          ],
        ),
      ),
    );
  }

  determineIngredientGrid(BuildContext context, WidgetRef ref, Function close) {
    return Padding(
      padding: const EdgeInsets.only(top: 25.0, bottom: 10.0),
      child: !product.isModifiable && product.hasToppings
          ? const SelectToppingsGridView()
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${product.isModifiable ? 'Current ' : ''}${product.isScheduled ? 'Items' : 'Ingredients'}',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Spacing().vertical(15),
                InkWell(
                  onTap: () {
                    determineModificationPageNavigation(ref, close);
                  },
                  child: UnmodifiableIngredientGridView(
                      product: product, close: close),
                ),
              ],
            ),
    );
  }

  determineSizeSelector() {
    if (product.isScheduled) {
      return const SizedBox();
    } else if (!product.isModifiable && !product.hasToppings) {
      return const SizedBox();
    } else {
      return SizeSelector(
        product: product,
      );
    }
  }

  determineModificationPageNavigation(WidgetRef ref, Function close) {
    if (product.isModifiable) {
      StandardIngredients(ref: ref).add();
      close();
    } else {
      return null;
    }
  }
}
