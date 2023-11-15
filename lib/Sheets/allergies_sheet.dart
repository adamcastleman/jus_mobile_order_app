import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/spacing_widgets.dart';
import 'package:jus_mobile_order_app/Providers/ProviderWidgets/allergen_ingredients_provider_widget.dart';
import 'package:jus_mobile_order_app/Providers/product_providers.dart';
import 'package:jus_mobile_order_app/Providers/theme_providers.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/close_button.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/confirm_button.dart';
import 'package:jus_mobile_order_app/Widgets/Cards/select_multiple_ingredients_card.dart';

class AllergiesSheet extends ConsumerWidget {
  const AllergiesSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final backgroundColor = ref.watch(backgroundColorProvider);
    return AllergenIngredientsProviderWidget(
      builder: (ingredients) => Container(
        color: backgroundColor,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          shrinkWrap: true,
          children: [
            Spacing().vertical(60),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                JusCloseButton(
                  removePadding: true,
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    ref.invalidate(selectedAllergiesProvider);
                    Navigator.pop(context);
                  },
                  iconSize: 22,
                ),
                const ConfirmButton(),
              ],
            ),
            Spacing().vertical(10),
            const Text(
              'Select allergies:',
              style: TextStyle(fontSize: 20),
            ),
            Spacing().vertical(10),
            const Text(
              'These are the ingredients we use in our stores.',
              style: TextStyle(fontSize: 12),
            ),
            Spacing().vertical(5),
            const Text(
              'If your allergy isn\'t listed, it\'s not a concern for this item.',
              style: TextStyle(fontSize: 12),
            ),
            Spacing().vertical(20),
            GridView.builder(
              shrinkWrap: true,
              primary: false,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 5,
                crossAxisSpacing: 5,
                childAspectRatio: 1 / 1.1,
              ),
              itemCount: ingredients.length,
              itemBuilder: (context, index) => SelectMultipleIngredientsCard(
                ingredient: ingredients[index],
                isAllergy: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
