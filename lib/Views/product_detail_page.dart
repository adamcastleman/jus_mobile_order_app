import 'package:animations/animations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Models/product_model.dart';
import 'package:jus_mobile_order_app/Providers/product_providers.dart';
import 'package:jus_mobile_order_app/Providers/theme_providers.dart';
import 'package:jus_mobile_order_app/Views/product_modifier_page.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/close_button.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/favorite_button.dart';
import 'package:jus_mobile_order_app/Widgets/General/select_product_options.dart';
import 'package:jus_mobile_order_app/Widgets/General/size_selector_price_display.dart';
import 'package:jus_mobile_order_app/Widgets/Helpers/loading.dart';
import 'package:jus_mobile_order_app/Widgets/Helpers/spacing_widgets.dart';
import 'package:jus_mobile_order_app/Widgets/Lists/select_toppings_grid_view.dart';
import 'package:jus_mobile_order_app/Widgets/Lists/unmodifiable_ingredient_grid.dart';

class ProductDetailPage extends ConsumerWidget {
  final ProductModel product;
  const ProductDetailPage({required this.product, super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final backgroundColor = ref.watch(themeColorProvider);
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: JusCloseButton(
          onPressed: () {
            Navigator.pop(context);
            ref.invalidate(selectedIngredientsProvider);
          },
        ),
        actions: const [
          FavoriteButton(),
        ],
      ),
      body: OpenContainer(
        tappable: false,
        openColor: backgroundColor!,
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
                    child: SizedBox(
                      height: 250,
                      child: CachedNetworkImage(
                        fit: BoxFit.fitWidth,
                        imageUrl: product.image,
                        placeholder: (context, url) => const Loading(),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      ),
                    ),
                  ),
                  Spacing().vertical(40),
                  Text(
                    product.name,
                    style: Theme.of(context).textTheme.headline5,
                  ),
                  Spacing().vertical(20),
                  SizeAndPriceSelector(
                    product: product,
                  ),
                  determineIngredientGrid(close),
                ],
              ),
            ),
            SelectProductOptions(
              close: close,
            ),
          ],
        ),
      ),
    );
  }

  determineIngredientGrid(Function close) {
    return Padding(
      padding: const EdgeInsets.only(top: 25.0, bottom: 10.0),
      child: product.isModifiable == false && product.hasToppings == true
          ? const SelectToppingsGridView(
              isQuickAdd: false,
            )
          : UnmodifiableIngredientGridView(close: close),
    );
  }
}
