import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Models/ingredient_model.dart';
import 'package:jus_mobile_order_app/Models/product_model.dart';
import 'package:jus_mobile_order_app/Providers/stream_providers.dart';
import 'package:jus_mobile_order_app/Widgets/Cards/select_ingredient_card.dart';
import 'package:jus_mobile_order_app/Widgets/Helpers/error.dart';
import 'package:jus_mobile_order_app/Widgets/Helpers/loading.dart';
import 'package:simple_grouped_listview/simple_grouped_listview.dart';

class IngredientGridView extends ConsumerWidget {
  final ProductModel product;
  const IngredientGridView({required this.product, super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ingredients = ref.watch(product.hasToppings == true
        ? modifiableIngredientsProvider
        : blendOnlyIngredientsProvider);
    return ingredients.when(
      loading: () => const Loading(),
      error: (e, _) => ShowError(error: e.toString()),
      data: (ingredients) => Padding(
        padding: const EdgeInsets.only(top: 8.0, left: 10, right: 10),
        child: GroupedListView.grid(
          crossAxisCount: 3,
          mainAxisSpacing: 6,
          crossAxisSpacing: 6,
          itemsAspectRatio: 1 / 1.14,
          items: ingredients,
          itemGrouper: (IngredientModel ingredient) => ingredient.category,
          headerBuilder: (context, String category) => Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: Text(
                category,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),
          ),
          gridItemBuilder: (context, int countInGroup, int itemIndexInGroup,
                  IngredientModel ingredient, int itemIndexInOriginalList) =>
              SelectIngredientCard(
            ingredients: ingredients,
            index: itemIndexInOriginalList,
          ),
        ),
      ),
    );
  }
}
