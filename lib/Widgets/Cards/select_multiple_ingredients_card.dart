import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Widgets/General/allergen_label.dart';
import 'package:jus_mobile_order_app/Widgets/Helpers/spacing_widgets.dart';

import '../../Models/ingredient_model.dart';
import '../../Providers/product_providers.dart';

class SelectMultipleIngredientsCard extends ConsumerWidget {
  final IngredientModel ingredient;
  final bool isAllergy;
  const SelectMultipleIngredientsCard(
      {required this.ingredient, required this.isAllergy, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      onTap: () {
        determineUpdatedProvider(ref);
      },
      child: SizedBox(
        width: 100,
        child: Card(
          color: determineCardColor(ref),
          shape: RoundedRectangleBorder(
            side: BorderSide(color: determineBorderColor(ref)),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Column(
            children: [
              SizedBox(
                height: 70,
                width: 70,
                child: CachedNetworkImage(
                  imageUrl: ingredient.image,
                ),
              ),
              Spacing().vertical(5),
              AutoSizeText(
                ingredient.name,
                style: const TextStyle(fontSize: 12),
                textAlign: TextAlign.center,
                maxLines: 2,
              ),
              AllergenLabel(
                ingredient: ingredient,
              ),
              Spacing().vertical(8),
            ],
          ),
        ),
      ),
    );
  }

  determineUpdatedProvider(WidgetRef ref) {
    final selectedToppings = ref.watch(selectedToppingsProvider);
    final selectedAllergies = ref.watch(selectedAllergiesProvider);
    if (isAllergy) {
      if (selectedAllergies.contains(ingredient.id)) {
        ref.read(selectedAllergiesProvider.notifier).remove(ingredient.id);
      } else {
        ref.read(selectedAllergiesProvider.notifier).add(ingredient.id);
      }
    } else {
      if (selectedToppings.contains(ingredient.id)) {
        ref.read(selectedToppingsProvider.notifier).remove(ingredient.id);
      } else {
        ref.read(selectedToppingsProvider.notifier).add(ingredient.id);
      }
    }
  }

  determineCardColor(WidgetRef ref) {
    final selectedToppings = ref.watch(selectedToppingsProvider);
    final selectedAllergies = ref.watch(selectedAllergiesProvider);
    if (isAllergy) {
      if (selectedAllergies.contains(ingredient.id)) {
        return Colors.blueGrey[50];
      } else {
        return Colors.white;
      }
    } else {
      if (selectedToppings.contains(ingredient.id)) {
        return Colors.blueGrey[50];
      } else {
        return Colors.white;
      }
    }
  }

  determineBorderColor(WidgetRef ref) {
    final selectedToppings = ref.watch(selectedToppingsProvider);
    final selectedAllergies = ref.watch(selectedAllergiesProvider);

    if (isAllergy) {
      if (selectedAllergies.contains(ingredient.id)) {
        return Colors.blueGrey;
      } else {
        return Colors.white;
      }
    } else {
      if (selectedToppings.contains(ingredient.id)) {
        return Colors.blueGrey;
      } else {
        return Colors.white;
      }
    }
  }
}
