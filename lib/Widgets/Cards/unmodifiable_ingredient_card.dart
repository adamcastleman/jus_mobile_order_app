import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Models/ingredient_model.dart';
import 'package:jus_mobile_order_app/Models/product_model.dart';
import 'package:jus_mobile_order_app/Providers/product_providers.dart';
import 'package:jus_mobile_order_app/Providers/stream_providers.dart';
import 'package:jus_mobile_order_app/Widgets/Helpers/error.dart';
import 'package:jus_mobile_order_app/Widgets/Helpers/loading.dart';
import 'package:jus_mobile_order_app/Widgets/Helpers/spacing_widgets.dart';

class UnmodifiableIngredientCard extends ConsumerWidget {
  final ProductModel product;
  final int index;
  const UnmodifiableIngredientCard(
      {required this.product, required this.index, super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ingredients = ref.watch(ingredientsProvider);
    final products = ref.watch(productsProvider);
    return ingredients.when(
      loading: () => const Loading(),
      error: (e, _) => ShowError(
        error: e.toString(),
      ),
      data: (ingredients) => products.when(
        loading: () => const Loading(),
        error: (e, _) => ShowError(
          error: e.toString(),
        ),
        data: (products) => Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
          child: Padding(
            padding: product.isScheduled
                ? const EdgeInsets.only(bottom: 15.0)
                : EdgeInsets.zero,
            child: Column(
              children: [
                SizedBox(
                  height: product.isScheduled ? 50 : 70,
                  width: product.isScheduled ? 50 : 70,
                  child: product.isScheduled
                      ? Center(
                          child: Text(
                            '${index + 1}',
                            style: const TextStyle(fontSize: 35),
                          ),
                        )
                      : CachedNetworkImage(
                          imageUrl: determineIngredientImage(ingredients, ref),
                        ),
                ),
                Padding(
                  padding: product.isScheduled
                      ? const EdgeInsets.symmetric(vertical: 4.0)
                      : EdgeInsets.zero,
                  child: AutoSizeText(
                    product.isScheduled
                        ? determineItemName(products, ref)
                        : determineIngredientName(ingredients, ref),
                    style: const TextStyle(
                      fontSize: 12,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                  ),
                ),
                Spacing().vertical(5),
                product.isScheduled
                    ? determineItemDescription(products, ref)
                    : determineIngredientAmountDescription(ingredients, ref),
              ],
            ),
          ),
        ),
      ),
    );
  }

  determineItemName(List<ProductModel> data, ref) {
    final standardItems = ref.watch(standardItemsProvider);
    return data
        .where((element) => element.productID == standardItems[index]['id'])
        .first
        .name;
  }

  determineItemImage(List<ProductModel> data, ref) {
    final standardItems = ref.watch(standardItemsProvider);
    return data
        .where((element) => element.productID == standardItems[index]['id'])
        .first
        .name;
  }

  determineItemDescription(List<ProductModel> data, ref) {
    final standardItems = ref.watch(standardItemsProvider);

    return AutoSizeText(
      data
          .where((element) => element.productID == (standardItems)[index]['id'])
          .first
          .description,
      maxLines: 3,
      maxFontSize: 10,
      minFontSize: 10,
      // overflow: TextOverflow.ellipsis,
      textAlign: TextAlign.center,
    );
  }

  determineIngredientImage(List<IngredientModel> data, ref) {
    final standardIngredients = ref.watch(standardIngredientsProvider);
    final selectedIngredients = ref.watch(selectedIngredientsProvider);

    return data
        .where((element) =>
            element.id ==
            (selectedIngredients.isEmpty
                ? standardIngredients
                : selectedIngredients)[index]['id'])
        .first
        .image;
  }

  determineIngredientName(List<IngredientModel> data, ref) {
    final standardIngredients = ref.watch(standardIngredientsProvider);
    final selectedIngredients = ref.watch(selectedIngredientsProvider);
    return data
        .where((element) =>
            element.id ==
            (selectedIngredients.isEmpty
                ? standardIngredients
                : selectedIngredients)[index]['id'])
        .first
        .name;
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
            'Topping: ${determineToppingAmountDisplay(data, ref)}',
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
