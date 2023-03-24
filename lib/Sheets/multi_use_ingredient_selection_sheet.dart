import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/spacing_widgets.dart';
import 'package:jus_mobile_order_app/Models/ingredient_model.dart';
import 'package:jus_mobile_order_app/Models/user_model.dart';
import 'package:jus_mobile_order_app/Providers/ProviderWidgets/modifiable_ingredients_provider_widget.dart';
import 'package:jus_mobile_order_app/Providers/ProviderWidgets/user_provider_widget.dart';
import 'package:jus_mobile_order_app/Providers/product_providers.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/elevated_button_medium.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/multi_use_ingredient_quantity_picker.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/outline_button_medium.dart';
import 'package:jus_mobile_order_app/Widgets/Cards/multi_use_ingredient_selection_cards.dart';

class MultiUseIngredientSelectionSheet extends ConsumerWidget {
  const MultiUseIngredientSelectionSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isExtraCharge = ref.watch(currentIngredientExtraChargeProvider);
    final selectedIngredientID = ref.watch(currentIngredientIDProvider);
    HapticFeedback.lightImpact();
    return ModifiableIngredientsProviderWidget(
      builder: (ingredients) => UserProviderWidget(
        builder: (user) {
          IngredientModel currentIngredient = ingredients
              .where((element) => element.id == selectedIngredientID)
              .first;
          return Wrap(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 12.0, vertical: 10.0),
                child: Text(
                  currentIngredient.name,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 24),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 28.0),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 30.0, right: 30.0, bottom: 30.0, top: 20.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Blended',
                                style: TextStyle(fontSize: 20),
                              ),
                              isExtraCharge
                                  ? MultiUseIngredientQuantityPicker(
                                      index: 0,
                                      currentIngredient: currentIngredient)
                                  : const MultiUseIngredientSelectionCards(
                                      index: 0,
                                    ),
                            ],
                          ),
                          Spacing().vertical(22),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'As Topping',
                                style: TextStyle(fontSize: 20),
                              ),
                              isExtraCharge
                                  ? MultiUseIngredientQuantityPicker(
                                      index: 1,
                                      currentIngredient: currentIngredient)
                                  : const MultiUseIngredientSelectionCards(
                                      index: 1,
                                    ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        MediumOutlineButton(
                          buttonText: 'Cancel',
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        MediumElevatedButton(
                            buttonText: 'Confirm',
                            onPressed: () {
                              modifyIngredient(ingredients, user, ref);
                              Navigator.pop(context);
                            }),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  modifyIngredient(
      List<IngredientModel> ingredients, UserModel user, WidgetRef ref) {
    final ingredientIndex = ref.watch(currentIngredientIndexProvider);
    final isExtraCharge = ref.watch(currentIngredientExtraChargeProvider);
    final isBlended = ref.watch(currentIngredientBlendedProvider);
    final isTopping = ref.watch(currentIngredientToppingProvider);
    final selectedIngredients = ref.watch(selectedIngredientsProvider);
    final selectedIngredientID = ref.watch(currentIngredientIDProvider);
    final blendedItemQuantity =
        ref.watch(extraChargeBlendedIngredientQuantityProvider);
    final toppedItemQuantity =
        ref.watch(extraChargeToppedIngredientQuantityProvider);
    Iterable<dynamic> currentIngredient = selectedIngredients
        .where((element) => element['id'] == selectedIngredientID);

    //All extra charged ingredients are handled first - followed by non-charge ingredients//

    //User has selected '0 Quantity' to both blended and topping in charged new ingredient. No action, just pops
    if (currentIngredient.isEmpty &&
        isExtraCharge &&
        blendedItemQuantity == 0 &&
        toppedItemQuantity == 0) {
      //User has selected '0 Quantity' to both blended and topping while editing a charged ingredient. Deletes the ingredient.
    } else if (currentIngredient.isNotEmpty &&
        isExtraCharge &&
        blendedItemQuantity == 0 &&
        toppedItemQuantity == 0) {
      ref
          .read(selectedIngredientsProvider.notifier)
          .removeIngredient(selectedIngredientID!, ref, selectedIngredients);
      //User is adding a new ingredient that can be both topped, blended,
      //and has an extra charge, to the list.
    } else if (currentIngredient.isEmpty && isExtraCharge) {
      ref.read(selectedIngredientsProvider.notifier).addIngredient(
            ingredients: ingredients,
            index: ingredientIndex!,
            isExtraCharge: isExtraCharge,
            ref: ref,
            user: user,
            blended: blendedItemQuantity,
            topping: toppedItemQuantity,
          );
      //User is editing quantity amounts of a charged ingredient that is both blended and topping.
    } else if (currentIngredient.isNotEmpty && isExtraCharge) {
      ref.read(selectedIngredientsProvider.notifier).addQuantityAmount(
            index: ingredientIndex!,
            isExtraCharge: isExtraCharge,
            ref: ref,
            ingredients: ingredients,
            user: user,
            blended: blendedItemQuantity,
            topping: toppedItemQuantity,
          );
    }
    //User has selected 'No' to both blended and topping in non-charged new ingredient. No action, just pops
    else if (isBlended == 1 && isTopping == 1 && currentIngredient.isEmpty) {
    }
    //User has selected 'No' to both blended and topping while editing a non-charged ingredient already in list.
    else if (isBlended == 1 && isTopping == 1 && currentIngredient.isNotEmpty) {
      ref
          .read(selectedIngredientsProvider.notifier)
          .removeIngredient(selectedIngredientID!, ref, selectedIngredients);
      //User is adding a new ingredient to the list that can be topped, blended,
      //and has no extra charge.
    } else if (currentIngredient.isEmpty) {
      ref.read(selectedIngredientsProvider.notifier).addIngredient(
          ingredients: ingredients,
          index: ingredientIndex!,
          isExtraCharge: isExtraCharge,
          ref: ref,
          user: user,
          blended: isBlended,
          topping: isTopping);
      //User is editing the topped or blended option in a non-charged ingredient already included in list
    } else {
      ref.read(selectedIngredientsProvider.notifier).addQuantityAmount(
          index: ingredientIndex!,
          ref: ref,
          ingredients: ingredients,
          isExtraCharge: isExtraCharge,
          user: user,
          blended: isBlended,
          topping: isTopping);
    }
  }
}
