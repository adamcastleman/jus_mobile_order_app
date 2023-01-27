import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Models/ingredient_model.dart';
import 'package:jus_mobile_order_app/Models/user_model.dart';
import 'package:jus_mobile_order_app/Providers/product_providers.dart';
import 'package:jus_mobile_order_app/Providers/stream_providers.dart';
import 'package:jus_mobile_order_app/Widgets/Helpers/error.dart';
import 'package:jus_mobile_order_app/Widgets/Helpers/loading.dart';
import 'package:jus_mobile_order_app/Widgets/Helpers/spacing_widgets.dart';

import '../../Models/product_model.dart';

class OrderTileDisplayModifications extends ConsumerWidget {
  final int orderIndex;
  final ProductModel currentProduct;

  const OrderTileDisplayModifications(
      {required this.orderIndex, required this.currentProduct, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentOrder = ref.watch(currentOrderItemsProvider);
    final currentUser = ref.watch(currentUserProvider);
    TextStyle style =
        const TextStyle(fontSize: 12, overflow: TextOverflow.visible);
    final selectedIngredients = currentOrder[orderIndex]['selectedIngredients'];
    final selectedToppings = currentOrder[orderIndex]['selectedToppings'];
    final allergies = currentOrder[orderIndex]['allergies'];
    final ingredients = ref.watch(ingredientsProvider);
    final adjusted = modifiedStandardItems(ref);
    final removed = removedItems(ref);
    final added = addedItems(ref);

    if ((!currentProduct.isScheduled &&
            !currentProduct.isModifiable &&
            !currentProduct.hasToppings) ||
        selectedIngredients == null) {
      return const SizedBox();
    } else {
      return ingredients.when(
        loading: () => const Loading(),
        error: (e, _) => ShowError(
          error: e.toString(),
        ),
        data: (item) => currentUser.when(
          loading: () => const Loading(),
          error: (e, _) => ShowError(
            error: e.toString(),
          ),
          data: (user) => Column(
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
                      final ingredient = item.firstWhere(
                          (element) => element.id == selectedToppings[index]);
                      return Text('+${ingredient.name}',
                          style: const TextStyle(
                            fontSize: 12,
                          ));
                    }),
              ),
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  primary: false,
                  itemCount: removed.length,
                  itemBuilder: (context, removedIngredientIndex) {
                    final ingredient = item.firstWhere((element) =>
                        element.id == removed[removedIngredientIndex]);
                    return Text('No ${ingredient.name}', style: style);
                  },
                ),
              ),
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  primary: false,
                  itemCount: adjusted == null ? 0 : adjusted.length,
                  itemBuilder: (context, adjustedIndex) {
                    var ingredient = item.firstWhere(
                      (element) => element.id == adjusted[adjustedIndex]['id'],
                    );
                    if (_getBlendedAndToppedStandardIngredientAmount(
                            adjusted, ingredient, adjustedIndex)
                        .isEmpty) {
                      return const SizedBox();
                    }
                    return Text(
                        _getBlendedAndToppedStandardIngredientAmount(
                            adjusted, ingredient, adjustedIndex),
                        style: style);
                  },
                ),
              ),
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  primary: false,
                  itemCount: added.length,
                  itemBuilder: (context, addedIngredientIndex) {
                    final ingredient = item.firstWhere((element) =>
                        element.id == added[addedIngredientIndex]['id']);
                    return Row(
                      children: [
                        Flexible(
                          child: Text(
                            '${blendedOrToppingDescription(ref, added, ingredient, addedIngredientIndex)}'
                            '${modifiedIngredientAmount(ref, added, ingredient, addedIngredientIndex)}'
                            ' ${ingredient.name}'
                            '${extraChargeQuantity(added, ingredient, addedIngredientIndex)}',
                            style: style,
                          ),
                        ),
                        Spacing().horizontal(5),
                        determineModifierPriceText(
                            user, added, addedIngredientIndex),
                      ],
                    );
                  },
                ),
              ),
              Spacing().vertical(2),
              allergies.isEmpty
                  ? const SizedBox()
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          child: Text(
                            'Allergies: ${List.generate(allergies.length, (index) => item.firstWhere((element) => element.id == allergies[index]).name).join(', ')}',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.visible,
                          ),
                        ),
                      ],
                    ),
            ],
          ),
        ),
      );
    }
  }

  String _getBlendedAndToppedStandardIngredientAmount(
      List<dynamic> adjusted, IngredientModel ingredient, int index) {
    final isBlended = adjusted[index]['blended'];
    final isTopped = adjusted[index]['topping'];
    if (adjusted[index]['amount'] == 1) {
      return '';
    }
    if (isBlended == null || isTopped == null) {
      if (adjusted[index]['amount'] == 0.5) {
        return 'Light ${ingredient.name}';
      } else if (adjusted[index]['amount'] == 2) {
        return 'Extra ${ingredient.name}';
      } else {
        return '';
      }
    } else {
      return 'No ${isBlended == 1 ? 'Blended' : 'Topped'} ${ingredient.name}';
    }
  }

  blendedOrToppingDescription(WidgetRef ref, List<dynamic> added,
      IngredientModel ingredient, int index) {
    final currentOrder = ref.watch(currentOrderItemsProvider);
    if (!currentOrder[orderIndex]['hasToppings']) {
      return '';
    } else if (ingredient.isTopping == false) {
      return '+';
    } else if (ingredient.isTopping &&
        added[index]['blended'] == 0 &&
        added[index]['topping'] == 1) {
      return '+ Blended';
    } else if (ingredient.isTopping &&
        added[index]['blended'] == 1 &&
        added[index]['topping'] == 0) {
      return '+ Topped';
    } else if (added[index]['blended'] == 1 && added[index]['topping'] == 1) {
      return '+ Blended & Topped';
    } else if (added[index]['isExtraCharge'] == true &&
        added[index]['blended'] == 0 &&
        added[index]['topping'] > 0) {
      return '+ Topped';
    } else if (added[index]['isExtraCharge'] == true &&
        added[index]['blended'] > 0 &&
        added[index]['topping'] == 0) {
      return '+ Blended';
    } else {
      return '+${added[index]['blended'] > 0 ? ' x${added[index]['blended']}' : ''} Blended & ${added[index]['topping'] > 0 ? 'x${added[index]['topping']} ' : ''}Topped';
    }
  }

  String modifiedIngredientAmount(WidgetRef ref, List<dynamic> added,
      IngredientModel ingredient, int index) {
    final currentOrder = ref.watch(currentOrderItemsProvider);
    if (currentOrder[orderIndex]['hasToppings']) {
      return '';
    }
    if (ingredient.isExtraCharge) {
      return '+';
    }
    if (added[index]['amount'] == 2) {
      return '+ Extra';
    }
    if (added[index]['amount'] == 0.5) {
      return '+ Light';
    }
    return '+';
  }

  extraChargeQuantity(
      List<dynamic> added, IngredientModel ingredient, int index) {
    if (ingredient.isExtraCharge == false || added[index]['amount'] < 2) {
      return '';
    } else if ((added[index]['blended'] != null &&
            added[index]['blended'] > 0) &&
        (added[index]['topping'] != null && added[index]['topping'] > 0)) {
      return '';
    } else {
      return ' x${added[index]['amount']}';
    }
  }

  determineModifierPriceText(UserModel user, List<dynamic> added, int index) {
    TextStyle textStyle =
        const TextStyle(fontSize: 11, fontWeight: FontWeight.bold);
    if (added[index]['isExtraCharge'] != true) {
      return const SizedBox();
    } else if (user.uid == null || !user.isActiveMember!) {
      return Text(
        '+\$${(num.tryParse(added[index]['price'])! / 100).toStringAsFixed(2)}',
        style: textStyle,
      );
    } else {
      return Text(
        '- Free',
        style: textStyle,
      );
    }
  }

  List<dynamic> removedItems(WidgetRef ref) {
    final currentOrder = ref.watch(currentOrderItemsProvider);
    final selectedIngredients = currentOrder[orderIndex]['selectedIngredients'];
    final standardIngredients = currentOrder[orderIndex]['standardIngredients'];

    if (selectedIngredients.isEmpty) {
      return [];
    }
    final standardIngredientsID =
        standardIngredients.map((ingredient) => ingredient['id']).toSet();
    final selectedIngredientsID =
        selectedIngredients.map((ingredient) => ingredient['id']).toSet();

    final removedIngredientsID =
        standardIngredientsID.difference(selectedIngredientsID);

    return removedIngredientsID.toList();
  }

  modifiedStandardItems(WidgetRef ref) {
    final currentOrder = ref.watch(currentOrderItemsProvider);
    final selectedIngredients = currentOrder[orderIndex]['selectedIngredients'];
    final standardIngredientsID = currentOrder[orderIndex]
            ['standardIngredients']
        .map((selected) => selected['id'])
        .toSet();

    return selectedIngredients
        .where((element) =>
            standardIngredientsID.contains(element['id']) == true &&
            element['amount'] != 1 &&
            element['isExtraCharge'] != true)
        .toList();
  }

  addedItems(WidgetRef ref) {
    final currentOrder = ref.watch(currentOrderItemsProvider);
    final selectedIngredients = currentOrder[orderIndex]['selectedIngredients'];
    final standardIngredientsID = currentOrder[orderIndex]
            ['standardIngredients']
        .map((selected) => selected['id'])
        .toSet();

    return selectedIngredients
        .where(
            (ingredient) => !standardIngredientsID.contains(ingredient['id']))
        .toList();
  }
}
