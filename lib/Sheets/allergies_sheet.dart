import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/spacing_widgets.dart';
import 'package:jus_mobile_order_app/Helpers/utilities.dart';
import 'package:jus_mobile_order_app/Providers/product_providers.dart';
import 'package:jus_mobile_order_app/Providers/theme_providers.dart';
import 'package:jus_mobile_order_app/Widgets/Cards/select_multiple_ingredients_card.dart';
import 'package:jus_mobile_order_app/Widgets/Headers/sheet_header.dart';

class AllergiesSheet extends ConsumerWidget {
  const AllergiesSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final backgroundColor = ref.watch(backgroundColorProvider);
    final allIngredients = ref.watch(allIngredientsProvider);
    final allergenIngredients = allIngredients
        .where((ingredient) => ingredient.includeInAllergiesList == true)
        .toList();
    return Container(
      padding: PlatformUtils.isWeb()
          ? EdgeInsets.zero
          : const EdgeInsets.only(top: 40.0, bottom: 20.0),
      color: backgroundColor,
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        shrinkWrap: true,
        children: [
          const SheetHeader(title: 'Select Allergies'),
          Spacing.vertical(10),
          const Text(
            'These are the ingredients we use in our stores.',
            style: TextStyle(fontSize: 12),
          ),
          Spacing.vertical(5),
          const Text(
            'If your allergy isn\'t listed, it\'s not a concern for this item.',
            style: TextStyle(fontSize: 12),
          ),
          Spacing.vertical(20),
          GridView.builder(
            padding: PlatformUtils.isWeb()
                ? const EdgeInsets.only(bottom: 12.0)
                : EdgeInsets.zero,
            shrinkWrap: true,
            primary: false,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 1 / 1.2,
            ),
            itemCount: allergenIngredients.length,
            itemBuilder: (context, index) => SelectMultipleIngredientsCard(
              ingredient: allergenIngredients[index],
              isAllergy: true,
            ),
          ),
        ],
      ),
    );
  }
}
