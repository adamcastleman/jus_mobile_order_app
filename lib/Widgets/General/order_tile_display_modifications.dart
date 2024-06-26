import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/products.dart';
import 'package:jus_mobile_order_app/Helpers/spacing_widgets.dart';
import 'package:jus_mobile_order_app/Providers/product_providers.dart';
import 'package:jus_mobile_order_app/Providers/stream_providers.dart';

import '../../Models/product_model.dart';

class OrderTileDisplayModifications extends ConsumerWidget {
  final int orderIndex;
  final ProductModel currentProduct;

  const OrderTileDisplayModifications(
      {required this.orderIndex, required this.currentProduct, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider).value!;
    final currentOrder = ref.watch(currentOrderItemsProvider);
    final ingredients = ref.watch(allIngredientsProvider);
    final ProductHelpers productHelpers = ProductHelpers();
    TextStyle style = TextStyle(
      fontSize: 11,
      overflow: TextOverflow.visible,
      color: Colors.grey,
      fontFamily: GoogleFonts.quicksand().fontFamily,
    );
    final selectedIngredients = currentOrder[orderIndex]['selectedIngredients'];
    final selectedToppings = currentOrder[orderIndex]['selectedToppings'];
    final allergies = currentOrder[orderIndex]['allergies'];
    final adjusted = productHelpers.modifiedStandardItems(ref, orderIndex);
    final removed = productHelpers.removedItems(ref, orderIndex);
    final added = productHelpers.addedItems(ref, orderIndex);

    if ((!currentProduct.isScheduled &&
            !currentProduct.isModifiable &&
            !currentProduct.hasToppings) ||
        selectedIngredients == null) {
      return const SizedBox();
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: ListView.builder(
                shrinkWrap: true,
                primary: false,
                itemCount:
                    selectedToppings.isEmpty ? 0 : selectedToppings.length,
                itemBuilder: (context, index) {
                  final ingredient = ingredients.firstWhere(
                      (element) => element.id == selectedToppings[index]);
                  return Text('+${ingredient.name}',
                      style: const TextStyle(
                        fontSize: 11,
                      ));
                }),
          ),
          Flexible(
            child: ListView.builder(
              shrinkWrap: true,
              primary: false,
              itemCount: removed.isEmpty ? 0 : removed.length,
              itemBuilder: (context, removedIngredientIndex) {
                final ingredient = ingredients.firstWhere(
                    (element) => element.id == removed[removedIngredientIndex]);
                return Text('No ${ingredient.name}', style: style);
              },
            ),
          ),
          Flexible(
            child: ListView.builder(
              shrinkWrap: true,
              primary: false,
              itemCount: (adjusted.isEmpty || adjusted.first.isEmpty)
                  ? 0
                  : adjusted.length,
              itemBuilder: (context, adjustedIndex) {
                var ingredient = ingredients.firstWhere(
                  (element) => element.id == adjusted[adjustedIndex]['id'],
                );
                if (productHelpers
                    .getBlendedAndToppedStandardIngredientAmount(
                        adjusted, ingredient, adjustedIndex)
                    .isEmpty) {
                  return const SizedBox();
                }
                return Text(
                    productHelpers.getBlendedAndToppedStandardIngredientAmount(
                        adjusted, ingredient, adjustedIndex),
                    style: style);
              },
            ),
          ),
          Flexible(
            child: ListView.builder(
              shrinkWrap: true,
              primary: false,
              itemCount:
                  added.isEmpty || added.first.isEmpty ? 0 : added.length,
              itemBuilder: (context, addedIngredientIndex) {
                final ingredient = ingredients.firstWhere((element) =>
                    element.id == added[addedIngredientIndex]['id']);

                return Row(
                  children: [
                    Flexible(
                      child: RichText(
                        text: TextSpan(style: style, children: [
                          TextSpan(
                              text:
                                  '${productHelpers.blendedOrToppingDescription(ref, added, ingredient, orderIndex, addedIngredientIndex)}'),
                          TextSpan(
                              text: productHelpers.modifiedIngredientAmount(
                                  added, ingredient, addedIngredientIndex)),
                          TextSpan(text: ' ${ingredient.name}'),
                          TextSpan(
                            text: (() {
                              int quantity =
                                  productHelpers.extraChargeIngredientQuantity(
                                      added, addedIngredientIndex);
                              if (quantity > 1) {
                                return ' x$quantity';
                              }
                              return '';
                            })(),
                          ),
                          TextSpan(
                            text:
                                ' ${productHelpers.determineModifierPriceText(user, added, addedIngredientIndex)}',
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 11,
                            ),
                          ),
                        ]),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          Spacing.vertical(2),
          allergies.isEmpty
              ? const SizedBox()
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: Text(
                        'Allergies: ${List.generate(allergies.length, (index) => ingredients.firstWhere((element) => element.id == allergies[index]).name).join(', ')}',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.visible,
                      ),
                    ),
                  ],
                ),
        ],
      );
    }
  }
}
