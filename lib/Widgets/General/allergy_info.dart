import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/error.dart';
import 'package:jus_mobile_order_app/Helpers/loading.dart';
import 'package:jus_mobile_order_app/Models/product_model.dart';
import 'package:jus_mobile_order_app/Providers/product_providers.dart';
import 'package:jus_mobile_order_app/Providers/stream_providers.dart';
import 'package:jus_mobile_order_app/Widgets/Cards/modify_allergy_grid_card.dart';
import 'package:jus_mobile_order_app/Widgets/General/allergen_label.dart';

class AllergyInfo extends ConsumerWidget {
  final ProductModel product;
  const AllergyInfo({required this.product, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allergies = ref.watch(selectedAllergiesProvider);
    final ingredients = ref.watch(modifiableIngredientsProvider);

    return ingredients.when(
      loading: () => const Loading(),
      error: (e, _) => ShowError(
        error: e.toString(),
      ),
      data: (data) {
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
                  product.isScheduled ||
                          (!product.isModifiable && !product.hasToppings)
                      ? const Text(
                          'This item is produced at a facility that also handles tree nuts, dairy, and gluten. We cannot guarantee this item will remain free of cross-contamination. However, we do take active precautions to limit exposure to these allergens wherever possible.')
                      : GridView.builder(
                          padding: const EdgeInsets.all(8.0),
                          primary: false,
                          shrinkWrap: true,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            childAspectRatio: 1 / 1.2,
                            crossAxisCount: 3,
                            mainAxisSpacing: 3,
                            crossAxisSpacing: 3,
                          ),
                          itemCount:
                              allergies.isEmpty ? 1 : allergies.length + 1,
                          itemBuilder: (context, index) {
                            if (index == allergies.length) {
                              return const ModifyAllergyGridCard();
                            } else {
                              final currentIngredient = data
                                  .where((element) =>
                                      element.id == allergies[index])
                                  .first;
                              return Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4.0)),
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: 70,
                                      width: 70,
                                      child: CachedNetworkImage(
                                        imageUrl: currentIngredient.image,
                                      ),
                                    ),
                                    Text(
                                      currentIngredient.name,
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                    AllergenLabel(
                                      ingredient: currentIngredient,
                                    ),
                                  ],
                                ),
                              );
                            }
                          }),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
