import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/spacing_widgets.dart';
import 'package:jus_mobile_order_app/Models/ingredient_model.dart';
import 'package:jus_mobile_order_app/Models/user_model.dart';
import 'package:jus_mobile_order_app/Providers/product_providers.dart';
import 'package:jus_mobile_order_app/Providers/stream_providers.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/elevated_button_medium.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/multi_use_ingredient_quantity_picker.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/outlined_button_medium.dart';

class MultiUseIngredientSelectionSheet extends ConsumerWidget {
  const MultiUseIngredientSelectionSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider).value ?? const UserModel();
    final ingredients = ref.watch(allIngredientsProvider);
    final selectedIngredientID = ref.watch(currentIngredientIdProvider);
    final modifiableIngredients =
        ingredients.where((element) => element.isModifiable == true).toList();

    final IngredientModel currentIngredient =
        ingredients.firstWhere((element) => element.id == selectedIngredientID);

    return Wrap(
      children: [
        _buildIngredientTitle(currentIngredient),
        _buildIngredientOptions(ref, currentIngredient),
        Padding(
          padding: const EdgeInsets.only(bottom: 30.0),
          child: _buildActionButtons(context, ref, modifiableIngredients, user),
        ),
      ],
    );
  }

  Widget _buildIngredientTitle(IngredientModel ingredient) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
      child: Text(
        ingredient.name,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
      ),
    );
  }

  Widget _buildIngredientOptions(WidgetRef ref, IngredientModel ingredient) {
    final isExtraCharge = ref.watch(currentIngredientExtraChargeProvider);
    final isBlended = ref.watch(currentIngredientBlendedProvider);
    final isTopping = ref.watch(currentIngredientToppingProvider);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            children: [
              _buildBlendedOption(ref, isExtraCharge, ingredient, isBlended),
              Spacing.vertical(22),
              _buildToppingOption(ref, isExtraCharge, ingredient, isTopping),
              Spacing.vertical(12),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBlendedOption(WidgetRef ref, bool isExtraCharge,
      IngredientModel currentIngredient, bool isBlended) {
    return isExtraCharge
        ? Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Blended',
                style: TextStyle(fontSize: 20),
              ),
              MultiUseIngredientQuantityPicker(
                index: 0,
                currentIngredient: currentIngredient,
              )
            ],
          )
        : CheckboxListTile(
            title: const Text(
              'Blended',
              style: TextStyle(fontSize: 20),
            ),
            value: isBlended,
            onChanged: (value) {
              ref.read(currentIngredientBlendedProvider.notifier).state =
                  value!;
            },
          );
  }

  Widget _buildToppingOption(WidgetRef ref, bool isExtraCharge,
      IngredientModel currentIngredient, bool isTopping) {
    return isExtraCharge
        ? Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'As Topping',
                style: TextStyle(fontSize: 20),
              ),
              MultiUseIngredientQuantityPicker(
                index: 1,
                currentIngredient: currentIngredient,
              )
            ],
          )
        : CheckboxListTile(
            title: const Text(
              'As Topping',
              style: TextStyle(fontSize: 20),
            ),
            value: isTopping,
            onChanged: (value) {
              ref.read(currentIngredientToppingProvider.notifier).state =
                  value!;
            },
          );
  }

  Widget _buildActionButtons(BuildContext context, WidgetRef ref,
      List<IngredientModel> ingredients, UserModel user) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: MediumOutlineButton(
              buttonText: 'Cancel',
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          Spacing.horizontal(22),
          Expanded(
            child: MediumElevatedButton(
              buttonText: 'Confirm',
              onPressed: () {
                modifyIngredient(ingredients, user, ref);
                Navigator.pop(context);
              },
            ),
          ),
        ],
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
    final selectedIngredientID = ref.watch(currentIngredientIdProvider);
    final blendedItemQuantity =
        ref.watch(extraChargeBlendedIngredientQuantityProvider);
    final toppedItemQuantity =
        ref.watch(extraChargeToppedIngredientQuantityProvider);
    Iterable<dynamic> currentIngredient = selectedIngredients
        .where((element) => element['id'] == selectedIngredientID);

    //All extra charged ingredients are handled first - followed by non-charge ingredients//

    //User has selected '0 Quantity' to both blended and topping in charged new ingredient.
    // No action, just pops
    if (currentIngredient.isEmpty &&
        isExtraCharge &&
        blendedItemQuantity == 0 &&
        toppedItemQuantity == 0) {
      //User has selected '0 Quantity' to both blended and topping while editing
      //a charged ingredient. Deletes the ingredient.
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
            ingredient: ingredients
                .firstWhere((element) => element.id == selectedIngredientID),
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
    else if (isBlended == false &&
        isTopping == false &&
        currentIngredient.isEmpty) {
    }
    //User has selected 'No' to both blended and topping while editing a non-charged ingredient already in list.
    else if (isBlended == false &&
        isTopping == false &&
        currentIngredient.isNotEmpty) {
      ref
          .read(selectedIngredientsProvider.notifier)
          .removeIngredient(selectedIngredientID!, ref, selectedIngredients);
      //User is adding a new ingredient to the list that can be topped, blended,
      //and has no extra charge.
    } else if (currentIngredient.isEmpty) {
      ref.read(selectedIngredientsProvider.notifier).addIngredient(
            ingredient: ingredients[ingredientIndex!],
            isExtraCharge: isExtraCharge,
            ref: ref,
            user: user,
            blended: isBlended == true ? 0 : 1,
            topping: isTopping == true ? 0 : 1,
          );
      //User is editing the topped or blended option in a non-charged ingredient already included in list
    } else {
      ref.read(selectedIngredientsProvider.notifier).addQuantityAmount(
            index: ingredientIndex!,
            ref: ref,
            ingredients: ingredients,
            isExtraCharge: isExtraCharge,
            user: user,
            blended: isBlended == true ? 0 : 1,
            topping: isTopping == true ? 0 : 1,
          );
    }
  }
}
