import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/modal_bottom_sheets.dart';
import 'package:jus_mobile_order_app/Models/ingredient_model.dart';
import 'package:jus_mobile_order_app/Models/product_model.dart';
import 'package:jus_mobile_order_app/Providers/ProviderWidgets/modifiable_ingredients_provider_widget.dart';
import 'package:jus_mobile_order_app/Providers/controller_providers.dart';
import 'package:jus_mobile_order_app/Providers/product_providers.dart';
import 'package:jus_mobile_order_app/Sheets/invalid_modification_sheet.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/elevated_button_medium.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/outlined_button_medium.dart';

class SelectModifierOptions extends ConsumerWidget {
  final ProductModel product;
  const SelectModifierOptions({required this.product, super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ModifiableIngredientsProviderWidget(
      builder: (ingredients) => Material(
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
                  checkForRequiredIngredients(context, ref, ingredients);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  MediumOutlineButton buildCancelButton(BuildContext context) {
    return MediumOutlineButton(
      buttonText: 'Cancel',
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }

  MediumOutlineButton buildResetButton(BuildContext context, WidgetRef ref) {
    return MediumOutlineButton(
      buttonText: 'Reset',
      onPressed: () {
        ref.read(selectedIngredientsProvider.notifier).replaceIngredients(ref);
        ref.read(modifyIngredientsListScrollControllerProvider).jumpTo(0);
      },
    );
  }

  Widget determineResetOrCancelButton(BuildContext context, WidgetRef ref) {
    final selectedIngredients = ref.watch(selectedIngredientsProvider);
    final standardIngredients = ref.watch(standardIngredientsProvider);
    Function isEqual = const DeepCollectionEquality.unordered().equals;

    if (isEqual(standardIngredients, selectedIngredients)) {
      return buildCancelButton(context);
    } else {
      return buildResetButton(context, ref);
    }
  }

  checkForRequiredIngredients(
      BuildContext context, WidgetRef ref, List<IngredientModel> data) {
    final selectedIngredients = ref.watch(selectedIngredientsProvider);
    final selectedNonBlendedIngredients = _filterSelectedNonBlendedIngredients(
        selectedIngredients: selectedIngredients, ingredients: data);

    if (!_hasFruit(selectedNonBlendedIngredients)) {
      return ModalBottomSheet().partScreen(
        isScrollControlled: true,
        isDismissible: true,
        enableDrag: true,
        context: context,
        builder: (context) => InvalidModificationSheet(
            category: '${product.hasToppings ? 'blended ' : ''}fruit'),
      );
    } else if (!_hasLiquids(selectedNonBlendedIngredients)) {
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

  List<IngredientModel> _filterSelectedNonBlendedIngredients(
      {required List selectedIngredients,
      required List<IngredientModel> ingredients}) {
    final List nonBlendedIngredientsIds = selectedIngredients
        .where((selected) =>
            selected['blended'] == 0 || selected['blended'] == null)
        .map((selected) => selected['id'])
        .toList();

    final List<IngredientModel> nonBlendedIngredients = ingredients
        .where((ingredient) => nonBlendedIngredientsIds.contains(ingredient.id))
        .toList();

    return nonBlendedIngredients;
  }

  bool _hasFruit(List<IngredientModel> ingredients) {
    return ingredients.any((ingredient) => ingredient.category == 'Fruits');
  }

  bool _hasLiquids(List<IngredientModel> ingredients) {
    return ingredients.any((ingredient) => ingredient.category == 'Liquids');
  }
}
