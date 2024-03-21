import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Models/ingredient_model.dart';
import 'package:jus_mobile_order_app/Providers/stream_providers.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/close_button.dart';
import 'package:jus_mobile_order_app/Widgets/General/display_ingredient_prices.dart';
import 'package:jus_mobile_order_app/Widgets/General/ingredient_amount_descriptive_text.dart';
import 'package:jus_mobile_order_app/Widgets/General/multi_use_ingredient_text.dart';
import 'package:jus_mobile_order_app/Widgets/General/selection_incrementor.dart';

import '../../Providers/product_providers.dart';
import '../General/multi_use_ingredient_edit_row.dart';

class ModifyItemWithToppingsCard extends HookConsumerWidget {
  final int index;

  const ModifyItemWithToppingsCard({required this.index, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider).value!;
    final ingredients = ref.watch(allIngredientsProvider);
    final selectedIngredients = ref.watch(selectedIngredientsProvider);
    final rotateController = useAnimationController();
    rotateController.repeat(
      min: 0.0,
      max: 0.01,
      period: const Duration(milliseconds: 1000),
      reverse: true,
    );

    IngredientModel currentIngredient = ingredients
        .where((element) => element.id == selectedIngredients[index]['id'])
        .first;
    return SizedBox(
      width: 125,
      child: RotationTransition(
        turns: Tween(begin: 0.0, end: 1.0).animate(rotateController),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
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
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        SizedBox(
                          height: 60,
                          width: 60,
                          child: CachedNetworkImage(
                              imageUrl: currentIngredient.image),
                        ),
                        Column(
                          children: [
                            AutoSizeText(
                              currentIngredient.name,
                              maxLines: 1,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 10,
                              ),
                            ),
                            currentIngredient.isTopping &&
                                    currentIngredient.isBlended
                                ? const SizedBox()
                                : IngredientAmountDescriptiveText(
                                    index: index,
                                    currentIngredient: currentIngredient,
                                  ),
                          ],
                        ),
                      ],
                    ),
                    currentIngredient.isBlended && currentIngredient.isTopping
                        ? MultiUseIngredientText(index: index)
                        : DisplayPremiumIngredientPrices(index: index),
                    currentIngredient.isTopping && currentIngredient.isBlended
                        ? MultiUseIngredientEditRow(
                            index: index, currentIngredient: currentIngredient)
                        : SelectionIncrementer(
                            verticalPadding: 8.0,
                            horizontalPadding: 10.0,
                            iconSize: 20,
                            buttonSpacing: 18,
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
                                    user: user,
                                  );
                            },
                            onRemove: () {
                              ref
                                  .read(selectedIngredientsProvider.notifier)
                                  .removeQuantityAmount(
                                    index,
                                    ref,
                                    ingredients,
                                    user,
                                  );
                            },
                          ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
