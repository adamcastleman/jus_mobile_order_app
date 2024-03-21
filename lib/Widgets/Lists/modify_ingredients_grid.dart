import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Providers/product_providers.dart';
import 'package:jus_mobile_order_app/Widgets/Cards/recipe_card.dart';

class ModifyIngredientsGrid extends ConsumerWidget {
  const ModifyIngredientsGrid({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIngredients = ref.watch(selectedIngredientsProvider);
    final key = ref.watch(animatedListKeyProvider);
    return GridView.builder(
      key: key,
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 12,
        crossAxisSpacing: 10,
        childAspectRatio: 9 / 11,
      ),
      itemCount: selectedIngredients.length,
      itemBuilder: (context, index) => RecipeCard(index: index),
    );
  }
}
