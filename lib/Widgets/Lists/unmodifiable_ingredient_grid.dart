import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Providers/product_providers.dart';
import 'package:jus_mobile_order_app/Widgets/Cards/modify_ingredient_grid_card.dart';
import 'package:jus_mobile_order_app/Widgets/Cards/unmodifiable_ingredient_card.dart';

class UnmodifiableIngredientGridView extends ConsumerWidget {
  final Function close;
  const UnmodifiableIngredientGridView({required this.close, super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GridView.builder(
      padding: const EdgeInsets.all(0.0),
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      primary: false,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          childAspectRatio: 1 / 1.2,
          crossAxisCount: 3,
          mainAxisSpacing: 3,
          crossAxisSpacing: 3),
      itemCount: determineItemCount(ref),
      itemBuilder: (context, index) => determineItemBuilder(ref, index),
    );
  }

  determineItemCount(WidgetRef ref) {
    final standardIngredients = ref.watch(standardIngredientsProvider);
    final selectedIngredients = ref.watch(selectedIngredientsProvider);
    final isModifiable = ref.watch(isModifiableProductProvider);
    if (isModifiable) {
      if (selectedIngredients.isEmpty) {
        return standardIngredients.length + 1;
      } else {
        return selectedIngredients.length + 1;
      }
    } else {
      if (selectedIngredients.isEmpty) {
        return standardIngredients.length;
      } else {
        return selectedIngredients.length;
      }
    }
  }

  determineItemBuilder(WidgetRef ref, int index) {
    final standardIngredients = ref.watch(standardIngredientsProvider);
    final selectedIngredients = ref.watch(selectedIngredientsProvider);
    final isModifiable = ref.watch(isModifiableProductProvider);

    if (isModifiable) {
      if (selectedIngredients.isEmpty && index == standardIngredients.length) {
        return ModifyIngredientGridCard(close: close);
      } else if (selectedIngredients.isNotEmpty &&
          index == selectedIngredients.length) {
        return ModifyIngredientGridCard(close: close);
      }
      return UnmodifiableIngredientCard(
        index: index,
      );
    } else {
      return UnmodifiableIngredientCard(
        index: index,
      );
    }
  }
}
