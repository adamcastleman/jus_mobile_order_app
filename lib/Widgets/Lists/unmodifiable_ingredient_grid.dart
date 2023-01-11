import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Models/product_model.dart';
import 'package:jus_mobile_order_app/Providers/product_providers.dart';
import 'package:jus_mobile_order_app/Widgets/Cards/unmodifiable_ingredient_card.dart';

class UnmodifiableIngredientGridView extends ConsumerWidget {
  final ProductModel product;
  final Function close;
  const UnmodifiableIngredientGridView(
      {required this.product, required this.close, super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GridView.builder(
      padding: const EdgeInsets.all(0.0),
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      primary: false,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        childAspectRatio: product.isScheduled ? (1 / 1.3) : (1 / 1.2),
        crossAxisCount: 3,
        mainAxisSpacing: 3,
        crossAxisSpacing: 3,
      ),
      itemCount: determineItemCount(ref),
      itemBuilder: (context, index) => UnmodifiableIngredientCard(
        product: product,
        index: index,
      ),
    );
  }

  determineItemCount(WidgetRef ref) {
    final standardItems = ref.watch(standardItemsProvider);
    final standardIngredients = ref.watch(standardIngredientsProvider);
    final selectedIngredients = ref.watch(selectedIngredientsProvider);

    if (product.isScheduled) {
      return standardItems.length;
    } else {
      if (selectedIngredients.isEmpty) {
        return standardIngredients.length;
      } else {
        return selectedIngredients.length;
      }
    }
  }
}
