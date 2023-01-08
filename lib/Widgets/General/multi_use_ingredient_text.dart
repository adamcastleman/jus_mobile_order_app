import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Providers/product_providers.dart';

class MultiUseIngredientText extends ConsumerWidget {
  final int index;
  const MultiUseIngredientText({required this.index, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Blended: ${determineBlendedText(ref)}',
          style: const TextStyle(fontSize: 10),
        ),
        Text(
          'Topping: ${determineToppingText(ref)}',
          style: const TextStyle(fontSize: 10),
        ),
      ],
    );
  }

  determineBlendedText(WidgetRef ref) {
    final selectedIngredients = ref.watch(selectedIngredientsProvider);
    if (selectedIngredients[index]['isExtraCharge']) {
      return selectedIngredients[index]['blended'];
    } else {
      if (selectedIngredients[index]['blended'] == 0) {
        return 'Yes';
      } else {
        return 'No';
      }
    }
  }

  determineToppingText(WidgetRef ref) {
    final selectedIngredients = ref.watch(selectedIngredientsProvider);
    if (selectedIngredients[index]['isExtraCharge']) {
      return selectedIngredients[index]['topping'];
    } else {
      if (selectedIngredients[index]['topping'] == 0) {
        return 'Yes';
      } else {
        return 'No';
      }
    }
  }
}
