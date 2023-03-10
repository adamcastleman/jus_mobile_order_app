import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/error.dart';
import 'package:jus_mobile_order_app/Helpers/loading.dart';
import 'package:jus_mobile_order_app/Helpers/modal_bottom_sheets.dart';
import 'package:jus_mobile_order_app/Models/ingredient_model.dart';
import 'package:jus_mobile_order_app/Models/product_model.dart';
import 'package:jus_mobile_order_app/Providers/product_providers.dart';
import 'package:jus_mobile_order_app/Providers/stream_providers.dart';
import 'package:jus_mobile_order_app/Sheets/invalid_modification_sheet.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/elevated_button_medium.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/outline_button_medium.dart';

class SelectModifierOptions extends ConsumerWidget {
  final ProductModel product;
  const SelectModifierOptions({required this.product, super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ingredients = ref.watch(modifiableIngredientsProvider);
    return ingredients.when(
        data: (data) => Material(
              color: Colors.white,
              elevation: 50,
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 20.0, left: 20, right: 20, bottom: 40.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    determineResetOrCancelButton(context, ref),
                    MediumElevatedButton(
                      buttonText: 'Confirm',
                      onPressed: () {
                        checkForRequiredIngredients(context, ref, data);
                        HapticFeedback.mediumImpact();
                      },
                    ),
                  ],
                ),
              ),
            ),
        error: (e, _) => ShowError(
              error: e.toString(),
            ),
        loading: () => const Loading());
  }

  determineResetOrCancelButton(BuildContext context, WidgetRef ref) {
    final selectedIngredients = ref.watch(selectedIngredientsProvider);
    final standardIngredients = ref.watch(standardIngredientsProvider);
    Function isEqual = const DeepCollectionEquality.unordered().equals;
    if (isEqual(standardIngredients, selectedIngredients)) {
      return MediumOutlineButton(
        buttonText: 'Cancel',
        onPressed: () {
          Navigator.pop(context);
        },
      );
    } else {
      return MediumOutlineButton(
        buttonText: 'Reset',
        onPressed: () {
          ref
              .read(selectedIngredientsProvider.notifier)
              .replaceIngredients(ref);
        },
      );
    }
  }

  checkForRequiredIngredients(
      BuildContext context, WidgetRef ref, List<IngredientModel> data) {
    final selectedIngredients = ref.watch(selectedIngredientsProvider);

    List ingredientObjectsFromListOfSelectedIngredients = List.generate(
        selectedIngredients.length,
        (index) => data.where((element) =>
            element.id == selectedIngredients[index]['id'] &&
            (selectedIngredients[index]['blended'] == 0 ||
                selectedIngredients[index]['blended'] == null)));
    if (!ingredientObjectsFromListOfSelectedIngredients
        .join('')
        .contains('Fruits')) {
      return ModalBottomSheet().partScreen(
        isScrollControlled: true,
        isDismissible: true,
        enableDrag: true,
        context: context,
        builder: (context) => InvalidModificationSheet(
            category: '${product.hasToppings ? 'blended ' : ''}fruit'),
      );
    } else if (!ingredientObjectsFromListOfSelectedIngredients
        .join('')
        .contains('Liquids')) {
      return ModalBottomSheet().partScreen(
        isScrollControlled: true,
        isDismissible: true,
        enableDrag: true,
        context: context,
        builder: (context) =>
            const InvalidModificationSheet(category: 'liquid'),
      );
    } else {
      Navigator.pop(context);
    }
  }
}
