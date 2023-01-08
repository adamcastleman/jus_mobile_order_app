import 'package:flutter/material.dart';
import 'package:jus_mobile_order_app/Models/ingredient_model.dart';

class AllergenLabel extends StatelessWidget {
  final IngredientModel ingredient;
  const AllergenLabel({required this.ingredient, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const textStyle = TextStyle(fontSize: 10);
    if (ingredient.containsDairy == true) {
      return const Padding(
        padding: EdgeInsets.only(top: 4.0),
        child: Text(
          '(Dairy)',
          style: textStyle,
        ),
      );
    } else if (ingredient.containsGluten == true) {
      return const Padding(
        padding: EdgeInsets.only(top: 4.0),
        child: Text(
          '(Gluten)',
          style: textStyle,
        ),
      );
    } else {
      return const SizedBox();
    }
  }
}
