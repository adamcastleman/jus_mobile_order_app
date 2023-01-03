import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Models/ingredient_model.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/close_button.dart';
import 'package:jus_mobile_order_app/Widgets/General/display_ingredient_prices.dart';
import 'package:jus_mobile_order_app/Widgets/General/ingredient_amount_descriptive_text.dart';
import 'package:jus_mobile_order_app/Widgets/General/modify_ingredient_quantity_row.dart';
import 'package:jus_mobile_order_app/Widgets/General/multi_use_ingredient_text.dart';
import 'package:jus_mobile_order_app/Widgets/Helpers/error.dart';

import '../../Providers/product_providers.dart';
import '../../Providers/stream_providers.dart';
import '../General/multi_use_ingredient_edit_row.dart';
import '../Helpers/loading.dart';

class ModifyItemWithToppingsCard extends HookConsumerWidget {
  final int index;

  const ModifyItemWithToppingsCard({required this.index, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIngredients = ref.watch(selectedIngredientsProvider);
    final ingredients = ref.watch(modifiableIngredientsProvider);
    final controller = useAnimationController();
    controller.repeat(
      min: 0.0,
      max: 0.006,
      period: const Duration(milliseconds: 1200),
      reverse: true,
    );

    return ingredients.when(
      loading: () => const Loading(),
      error: (e, _) => ShowError(
        error: e.toString(),
      ),
      data: (data) {
        IngredientModel currentIngredient = data
            .where((element) => element.id == selectedIngredients[index]['id'])
            .first;
        return SizedBox(
          width: 125,
          child: RotationTransition(
            turns: Tween(begin: 0.0, end: 1.0).animate(controller),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 5.0),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4.0),
                ),
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: JusCloseButton(
                        removePadding: true,
                        iconSize: 18,
                        onPressed: () {
                          HapticFeedback.lightImpact();
                          ref
                              .read(selectedIngredientsProvider.notifier)
                              .removeIngredient(currentIngredient.id, ref,
                                  selectedIngredients);
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
                                    currentIngredient.isTopping &&
                                            currentIngredient.isBlended
                                        ? const SizedBox()
                                        : IngredientAmountDescriptiveText(
                                            index: index,
                                            currentIngredient:
                                                currentIngredient,
                                          ),
                                  ],
                                ),
                              ],
                            ),
                            currentIngredient.isBlended &&
                                    currentIngredient.isTopping
                                ? MultiUseIngredientText(index: index)
                                : DisplayPremiumIngredientPrices(index: index),
                            currentIngredient.isTopping &&
                                    currentIngredient.isBlended
                                ? MultiUseIngredientEditRow(
                                    index: index,
                                    currentIngredient: currentIngredient)
                                : ModifyIngredientQuantityRow(index: index),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
