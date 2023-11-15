import 'package:flutter/material.dart';
import 'package:jus_mobile_order_app/Models/ingredient_model.dart';

class AllergenLabel extends StatelessWidget {
  final IngredientModel ingredient;
  const AllergenLabel({required this.ingredient, super.key});

  @override
  Widget build(BuildContext context) {
    const textStyle = TextStyle(fontSize: 9);
    if (ingredient.allergens.isEmpty) {
      return const SizedBox();
    } else {
      // Join the allergens list into a comma-separated string.
      String allergensText = ingredient.allergens.join(', ');
      // Display the comma-separated string of allergens.
      return Text(
        'Contains $allergensText',
        style: textStyle,
        maxLines: 2,
      );
    }
  }
}
