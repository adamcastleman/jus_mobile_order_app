import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Models/ingredient_model.dart';
import 'package:jus_mobile_order_app/Providers/ProviderWidgets/modifiable_ingredients_provider_widget.dart';
import 'package:jus_mobile_order_app/Providers/product_providers.dart';
import 'package:jus_mobile_order_app/Providers/stream_providers.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/close_button.dart';
import 'package:jus_mobile_order_app/Widgets/General/display_ingredient_prices.dart';
import 'package:jus_mobile_order_app/Widgets/General/ingredient_amount_descriptive_text.dart';
import 'package:jus_mobile_order_app/Widgets/General/selection_incrementor.dart';

class ModifyItemNoToppingsCard extends HookConsumerWidget {
  final int index;

  const ModifyItemNoToppingsCard({required this.index, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider).value!;
    final selectedIngredients = ref.watch(selectedIngredientsProvider);
    final controller = useAnimationController();
    controller.repeat(
      min: 0.0,
      max: 0.01,
      period: const Duration(milliseconds: 1000),
      reverse: true,
    );

    return ModifiableIngredientsProviderWidget(
      builder: (ingredients) {
        IngredientModel currentIngredient = ingredients
            .where((element) => element.id == selectedIngredients[index]['id'])
            .first;
        return SizedBox(
          width: 125,
          child: RotationTransition(
            turns: Tween(begin: 0.0, end: 1.0).animate(controller),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4.0),
              ),
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: JusCloseButton(
                      removePadding: true,
                      iconSize: 18,
                      onPressed: () {
                        ref
                            .read(selectedIngredientsProvider.notifier)
                            .removeIngredient(
                                currentIngredient.id, ref, selectedIngredients);
                      },
                    ),
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              SizedBox(
                                height: 70,
                                width: 70,
                                child: CachedNetworkImage(
                                    imageUrl: currentIngredient.image),
                              ),
                              Column(
                                children: [
                                  AutoSizeText(
                                    currentIngredient.name,
                                    maxLines: 2,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                  IngredientAmountDescriptiveText(
                                    index: index,
                                    currentIngredient: currentIngredient,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          DisplayPremiumIngredientPrices(index: index),
                          SelectionIncrementer(
                            verticalPadding: 4.0,
                            horizontalPadding: 10.0,
                            buttonSpacing: 18,
                            iconSize: 20,
                            quantityRadius: 15,
                            quantity:
                                '${selectedIngredients[index]['amount'] == 0.5 ? '1/2' : selectedIngredients[index]['amount']}',
                            onAdd: () {
                              ref
                                  .read(selectedIngredientsProvider.notifier)
                                  .addQuantityAmount(
                                      index: index,
                                      ref: ref,
                                      isExtraCharge: ref.read(
                                          currentIngredientExtraChargeProvider),
                                      ingredients: ingredients,
                                      user: user);
                            },
                            onRemove: () {
                              ref
                                  .read(selectedIngredientsProvider.notifier)
                                  .removeQuantityAmount(
                                      index, ref, ingredients, user);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
