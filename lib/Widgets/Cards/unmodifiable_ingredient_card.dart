import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/spacing_widgets.dart';
import 'package:jus_mobile_order_app/Helpers/utilities.dart';
import 'package:jus_mobile_order_app/Models/ingredient_model.dart';
import 'package:jus_mobile_order_app/Models/product_model.dart';
import 'package:jus_mobile_order_app/Providers/product_providers.dart';

class UnmodifiableIngredientCard extends ConsumerWidget {
  final ProductModel product;
  final List<IngredientModel> ingredients;
  final int index;
  const UnmodifiableIngredientCard(
      {required this.product,
      required this.ingredients,
      required this.index,
      super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final products = ref.watch(allProductsProvider);
    if (product.isScheduled) {
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: Colors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 15.0),
          child: Column(
            children: [
              Spacing.vertical(10),
              Center(
                child: Text(
                  '${index + 1}',
                  style: const TextStyle(fontSize: 35),
                ),
              ),
              Spacing.vertical(10),
              _displayItemName(products),
              Spacing.vertical(10),
              _displayItemDescription(products),
            ],
          ),
        ),
      );
    } else {
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          color: Colors.white,
        ),
        child: Column(
          children: [
            Spacing.vertical(10),
            displayImage(context, ref, ingredients),
            Spacing.vertical(12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2.0),
              child: AutoSizeText(
                determineIngredientName(ingredients, ref),
                style: const TextStyle(fontSize: 12),
                textAlign: TextAlign.center,
                maxLines: 2,
              ),
            ),
            Spacing.vertical(10),
            determineIngredientAmountDescription(ingredients, ref),
            Spacing.vertical(10),
          ],
        ),
      );
    }
  }

  Widget _displayItemName(List<ProductModel> products) {
    return AutoSizeText(
      products
          .firstWhere(
              (item) => int.parse(item.productId) == product.ingredients[index])
          .name,
      style: const TextStyle(
        fontSize: 14,
      ),
      textAlign: TextAlign.center,
      maxLines: 1,
    );
  }

  Widget _displayItemDescription(List<ProductModel> products) {
    return AutoSizeText(
      products
          .firstWhere(
              (item) => int.parse(item.productId) == product.ingredients[index])
          .description,
      maxLines: 3,
      maxFontSize: 10,
      minFontSize: 10,
      // overflow: TextOverflow.ellipsis,
      textAlign: TextAlign.center,
    );
  }

  Widget displayImage(
    BuildContext context,
    WidgetRef ref,
    List<IngredientModel> ingredients,
  ) {
    if (ResponsiveLayout.isMobilePhone(context)) {
      return SizedBox(
        height: 60,
        width: product.isScheduled ? 48 : 90,
        child: CachedNetworkImage(
          imageUrl: determineIngredientImage(ingredients, ref),
        ),
      );
    } else {
      return ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: ResponsiveLayout.isWeb(context)
              ? 60
              : product.isScheduled
                  ? 35
                  : 70,
          maxWidth: 150,
        ),
        child: CachedNetworkImage(
          imageUrl: determineIngredientImage(ingredients, ref),
        ),
      );
    }
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
