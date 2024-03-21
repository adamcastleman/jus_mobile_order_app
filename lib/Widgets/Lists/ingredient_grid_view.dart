import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/utilities.dart';
import 'package:jus_mobile_order_app/Models/ingredient_model.dart';
import 'package:jus_mobile_order_app/Models/product_model.dart';
import 'package:jus_mobile_order_app/Providers/product_providers.dart';
import 'package:jus_mobile_order_app/Widgets/Cards/select_ingredient_card.dart';
import 'package:jus_mobile_order_app/constants.dart';
import 'package:simple_grouped_listview/simple_grouped_listview.dart';

class IngredientGridView extends ConsumerWidget {
  final ProductModel product;
  const IngredientGridView({required this.product, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allIngredients = ref.watch(allIngredientsProvider);
    final modifiableIngredients =
        allIngredients.where((item) => item.isModifiable == true).toList();
    final blendOnlyIngredients = allIngredients
        .where(
          (item) =>
              item.isBlended == true &&
              item.isModifiable == true &&
              item.isStandardTopping == false,
        )
        .toList();

    final ingredients =
        product.hasToppings ? modifiableIngredients : blendOnlyIngredients;

    return Padding(
      padding: const EdgeInsets.only(top: 8.0, left: 10, right: 10),
      child: GroupedListView.grid(
        padding: PlatformUtils.isWeb()
            ? const EdgeInsets.only(bottom: 40.0)
            : EdgeInsets.zero,
        crossAxisCount: _determineCrossAxisCount(context),
        mainAxisSpacing: 2,
        crossAxisSpacing: 2,
        itemsAspectRatio: _determineItemsAspectRatio(context),
        items: ingredients,
        itemGrouper: (ingredient) => ingredient.category,
        headerBuilder: (context, category) =>
            _buildHeader(context, category, ingredients),
        gridItemBuilder: (context, countInGroup, itemIndexInGroup, ingredient,
                itemIndexInOriginalList) =>
            SelectIngredientCard(
                ingredients: ingredients, index: itemIndexInOriginalList),
      ),
    );
  }

  int _determineCrossAxisCount(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width <= AppConstants.mobileBrowserWidth) return 3;
    if (width <= AppConstants.tabletWidth) return 4;
    return 5; // Default to 5 for wider screens
  }

  double _determineItemsAspectRatio(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < AppConstants.mobilePhoneWidth) return 1 / 1.2;
    if (width <= AppConstants.mobileBrowserWidth) return 1 / 1.05;
    return 1 / 1.14; // Default for wider screens
  }

  Widget _buildHeader(BuildContext context, String category,
      List<IngredientModel> ingredients) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 12.0),
        child: Text(
          category,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
    );
  }
}
