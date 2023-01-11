import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Widgets/Cards/modify_item_no_toppings_card.dart';
import 'package:jus_mobile_order_app/Widgets/Cards/modify_item_with_toppings_card.dart';

import '../../Providers/product_providers.dart';

class ModifyIngredientsList extends ConsumerWidget {
  const ModifyIngredientsList({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIngredients = ref.watch(selectedIngredientsProvider);

    final key = ref.watch(animatedListKeyProvider);
    return SizedBox(
      height: 160,
      child: AnimatedList(
        key: key,
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        scrollDirection: Axis.horizontal,
        initialItemCount: selectedIngredients.length,
        itemBuilder: (context, index, animation) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: SizeTransition(
            axis: Axis.horizontal,
            axisAlignment: 0.5,
            sizeFactor: animation,
            child: determineRecipeCard(ref, index),
          ),
        ),
      ),
    );
  }

  determineRecipeCard(WidgetRef ref, int index) {
    final hasToppings = ref.watch(productHasToppingsProvider);
    if (hasToppings) {
      return ModifyItemWithToppingsCard(index: index);
    } else {
      return ModifyItemNoToppingsCard(
        index: index,
      );
    }
  }
}
