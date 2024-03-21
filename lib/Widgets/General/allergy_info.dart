import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Models/ingredient_model.dart';
import 'package:jus_mobile_order_app/Models/product_model.dart';
import 'package:jus_mobile_order_app/Providers/product_providers.dart';
import 'package:jus_mobile_order_app/Widgets/Cards/modify_allergy_grid_card.dart';
import 'package:jus_mobile_order_app/Widgets/General/allergen_label.dart';
import 'package:jus_mobile_order_app/constants.dart';

class AllergyInfo extends ConsumerWidget {
  final ProductModel product;
  const AllergyInfo({required this.product, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allergies = ref.watch(selectedAllergiesProvider);
    final ingredients = ref.watch(allIngredientsProvider);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Allergies',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: _buildAllergiesGridView(allergies, ingredients),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAllergiesGridView(
      List<int> allergies, List<IngredientModel> ingredients) {
    if (product.isScheduled ||
        (!product.isModifiable && !product.hasToppings)) {
      return const Text(
        'This item is produced at a facility that also handles tree nuts, dairy, and gluten. We cannot guarantee this item will remain free of cross-contamination. However, we do take active precautions to limit exposure to these allergens wherever possible.',
      );
    }

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 500),
      child: GridView.builder(
        padding: const EdgeInsets.all(8.0),
        primary: false,
        shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          childAspectRatio: AppConstants.screenWidth > AppConstants.tabletWidth
              ? 9 / 11
              : 1 / 1.2,
          crossAxisCount: 3,
          mainAxisSpacing: 3,
          crossAxisSpacing: 3,
        ),
        itemCount: allergies.isEmpty ? 1 : allergies.length + 1,
        itemBuilder: (context, index) {
          if (index == allergies.length) {
            return const ModifyAllergyGridCard();
          } else {
            final currentIngredient = ingredients
                .firstWhere((element) => element.id == allergies[index]);
            return buildAllergyCard(currentIngredient);
          }
        },
      ),
    );
  }

  Widget buildAllergyCard(IngredientModel ingredient) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25),
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
          Text(
            ingredient.name,
            style: const TextStyle(fontSize: 12),
          ),
          AllergenLabel(ingredient: ingredient),
        ],
      ),
    );
  }
}
