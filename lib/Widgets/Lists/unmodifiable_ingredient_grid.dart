import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Models/ingredient_model.dart';
import 'package:jus_mobile_order_app/Models/product_model.dart';
import 'package:jus_mobile_order_app/Providers/product_providers.dart';
import 'package:jus_mobile_order_app/Widgets/Cards/unmodifiable_ingredient_card.dart';
import 'package:jus_mobile_order_app/constants.dart';

class UnmodifiableIngredientGridView extends ConsumerWidget {
  final ProductModel product;
  final List<IngredientModel> ingredients;
  const UnmodifiableIngredientGridView(
      {required this.product, required this.ingredients, super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      primary: false,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        childAspectRatio: _determineAspectRatio(context),
        crossAxisCount: 3,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
      ),
      itemCount: _determineItemCount(ref),
      itemBuilder: (context, index) => UnmodifiableIngredientCard(
        product: product,
        ingredients: ingredients,
        index: index,
      ),
    );
  }

  _determineItemCount(WidgetRef ref) {
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

  _determineAspectRatio(BuildContext context) {
    if (MediaQuery.of(context).size.width < AppConstants.mobilePhoneWidth) {
      return 1 / 1.5;
    } else {
      return 9 / 11;
    }
  }
}
