import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Models/ingredient_model.dart';
import 'package:jus_mobile_order_app/Providers/product_providers.dart';
import 'package:jus_mobile_order_app/Providers/stream_providers.dart';
import 'package:jus_mobile_order_app/Widgets/Helpers/error.dart';
import 'package:jus_mobile_order_app/Widgets/Helpers/loading.dart';
import 'package:jus_mobile_order_app/Widgets/Helpers/spacing_widgets.dart';

class UnmodifiableIngredientCard extends ConsumerWidget {
  final int index;
  const UnmodifiableIngredientCard({required this.index, super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ingredients = ref.watch(ingredientsProvider);
    return ingredients.when(
      loading: () => const Loading(),
      error: (e, _) => ShowError(
        error: e.toString(),
      ),
      data: (data) => Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
        child: Column(
          children: [
            SizedBox(
              height: 70,
              width: 70,
              child: CachedNetworkImage(
                imageUrl: determineIngredientImage(data, ref),
              ),
            ),
            AutoSizeText(
              determineIngredientName(data, ref),
              style: const TextStyle(fontSize: 12),
              textAlign: TextAlign.center,
              maxLines: 2,
            ),
            Spacing().vertical(5),
            determineIngredientAmountDescription(data, ref),
          ],
        ),
      ),
    );
  }

  determineIngredientImage(List<IngredientModel> data, ref) {
    final standardIngredients = ref.watch(standardIngredientsProvider);
    final selectedIngredients = ref.watch(selectedIngredientsProvider);
    if (selectedIngredients.isEmpty) {
      return data
          .where((element) => element.id == standardIngredients[index]['id'])
          .first
          .image;
    } else {
      return data
          .where((element) => element.id == selectedIngredients[index]['id'])
          .first
          .image;
    }
  }

  determineIngredientName(List<IngredientModel> data, ref) {
    final standardIngredients = ref.watch(standardIngredientsProvider);
    final selectedIngredients = ref.watch(selectedIngredientsProvider);
    if (selectedIngredients.isEmpty) {
      return data
          .where((element) => element.id == standardIngredients[index]['id'])
          .first
          .name;
    } else {
      return data
          .where((element) => element.id == selectedIngredients[index]['id'])
          .first
          .name;
    }
  }

  determineIngredientAmountDescription(List<IngredientModel> data, ref) {
    TextStyle amountStyle = const TextStyle(fontSize: 9);
    final selectedIngredients = ref.watch(selectedIngredientsProvider);
    final currentIngredientBlended =
        ref.watch(currentIngredientBlendedProvider);
    final currentIngredientTopping =
        ref.watch(currentIngredientToppingProvider);
    final productHasToppings = ref.watch(productHasToppingsProvider);
    if (selectedIngredients.isEmpty) {
      return const SizedBox();
    } else if (data
            .where((element) => element.id == selectedIngredients[index]['id'])
            .first
            .isBlended &&
        data
            .where((element) => element.id == selectedIngredients[index]['id'])
            .first
            .isTopping &&
        currentIngredientBlended != null &&
        currentIngredientTopping != null &&
        productHasToppings) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Blended: ${determineBlendedAmountDisplay(data, ref)}',
            style: amountStyle,
          ),
          Text(
            'Topping ${determineToppingAmountDisplay(data, ref)}',
            style: amountStyle,
          ),
        ],
      );
    } else if (data
        .where((element) => element.id == selectedIngredients[index]['id'])
        .first
        .isExtraCharge) {
      return Text(
        'Quantity: ${selectedIngredients[index]['amount']}',
        style: amountStyle,
      );
    } else if (selectedIngredients[index]['amount'] == 0.5) {
      return Text(
        '(Light)',
        style: amountStyle,
      );
    } else if (selectedIngredients[index]['amount'] == 2) {
      return Text(
        '(Extra)',
        style: amountStyle,
      );
    } else {
      return const SizedBox();
    }
  }

  determineBlendedAmountDisplay(List<IngredientModel> data, ref) {
    final selectedIngredients = ref.watch(selectedIngredientsProvider);

    final currentIngredient = data
        .where((element) => element.id == selectedIngredients[index]['id'])
        .first;
    final currentSelected = selectedIngredients
        .where((element) => element['id'] == currentIngredient.id)
        .first;

    if (currentIngredient.isBlended &&
        currentIngredient.isTopping &&
        currentIngredient.isExtraCharge) {
      return '${currentSelected['blended']}';
    } else {
      return currentSelected['blended'] == 0 ? 'Yes' : 'No';
    }
  }

  determineToppingAmountDisplay(List<IngredientModel> data, ref) {
    final selectedIngredients = ref.watch(selectedIngredientsProvider);
    final currentIngredient = data
        .where((element) => element.id == selectedIngredients[index]['id'])
        .first;
    final currentSelected = selectedIngredients
        .where((element) => element['id'] == currentIngredient.id)
        .first;

    if (currentIngredient.isBlended &&
        currentIngredient.isTopping &&
        currentIngredient.isExtraCharge) {
      return '${currentSelected['topping']}';
    } else {
      return currentSelected['topping'] == 0 ? 'Yes' : 'No';
    }
  }
}
