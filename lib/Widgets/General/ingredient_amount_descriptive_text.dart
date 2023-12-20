import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Models/ingredient_model.dart';
import 'package:jus_mobile_order_app/Providers/product_providers.dart';

class IngredientAmountDescriptiveText extends ConsumerWidget {
  final int index;
  final IngredientModel currentIngredient;
  const IngredientAmountDescriptiveText(
      {required this.index, required this.currentIngredient, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIngredients = ref.watch(selectedIngredientsProvider);

    if (currentIngredient.isExtraCharge) {
      return const SizedBox();
    } else {
      if (selectedIngredients[index]['amount'] == 0.5) {
        return const Text(
          '(Light)',
          maxLines: 1,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 10),
        );
      } else if (selectedIngredients[index]['amount'] == 2) {
        return const Text(
          '(Extra)',
          maxLines: 1,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 10),
        );
      } else {
        return const SizedBox();
      }
    }
  }
}
