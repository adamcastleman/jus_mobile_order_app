import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Providers/controller_providers.dart';
import 'package:jus_mobile_order_app/Widgets/Cards/recipe_card.dart';

import '../../Providers/product_providers.dart';

class ModifyIngredientsList extends ConsumerWidget {
  const ModifyIngredientsList({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIngredients = ref.watch(selectedIngredientsProvider);
    final controller = ref.watch(modifyIngredientsListScrollControllerProvider);
    final key = ref.watch(animatedListKeyProvider);

    return SizedBox(
      height: 160,
      child: AnimatedList(
        key: key,
        controller: controller,
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        scrollDirection: Axis.horizontal,
        initialItemCount: selectedIngredients.length,
        itemBuilder: (context, index, animation) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: SizeTransition(
            axis: Axis.horizontal,
            axisAlignment: 0.5,
            sizeFactor: animation,
            child: RecipeCard(index: index),
          ),
        ),
      ),
    );
  }
}
