import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Models/product_model.dart';
import 'package:jus_mobile_order_app/Providers/product_providers.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/elevated_button_large.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/elevated_button_medium.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/outline_button_medium.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/quantity_picker_button.dart';
import 'package:jus_mobile_order_app/Widgets/Helpers/pricing.dart';

import '../Helpers/set_standard_ingredients.dart';

class SelectProductOptions extends ConsumerWidget {
  final ProductModel product;
  final Function close;
  const SelectProductOptions(
      {required this.close, required this.product, super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Material(
      color: Colors.white,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      elevation: 30,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(
                top: 10.0, left: 20, right: 20, bottom: 40.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 18.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Quantity',
                        style: Theme.of(context).textTheme.headline6,
                      ),
                      const QuantityPickerButton(
                        daysPicker: false,
                      ),
                    ],
                  ),
                ),
                product.isScheduled
                    ? Padding(
                        padding: const EdgeInsets.only(bottom: 18.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Number of Days',
                              style: Theme.of(context).textTheme.headline6,
                            ),
                            const QuantityPickerButton(
                              daysPicker: true,
                            ),
                          ],
                        ),
                      )
                    : const SizedBox(),
                determineAddToCartRow(context, ref),
              ],
            ),
          ),
        ],
      ),
    );
  }

  determineAddToCartRow(BuildContext context, WidgetRef ref) {
    final isModifiable = ref.watch(isModifiableProductProvider);
    final editOrder = ref.watch(editOrderProvider);
    final standardIngredients = ref.watch(standardIngredientsProvider);
    final selectedIngredients = ref.watch(selectedIngredientsProvider);
    final itemQuantity = ref.watch(itemQuantityProvider);
    final daysQuantity = ref.watch(daysQuantityProvider);
    final itemSize = ref.watch(selectedSizeProvider);
    final hasToppings = ref.watch(productHasToppingsProvider);
    final selectedToppings = ref.watch(selectedToppingsProvider);
    final allergies = ref.watch(selectedAllergiesProvider);
    Map<String, dynamic> currentItem = {
      'productID': product.productID,
      'isScheduled': product.isScheduled,
      'isModifiable': product.isModifiable,
      'itemQuantity': itemQuantity,
      'daysQuantity': daysQuantity,
      'itemSize': itemSize,
      'hasToppings': hasToppings,
      'selectedIngredients': selectedIngredients,
      'standardIngredients': standardIngredients,
      'selectedToppings': selectedToppings,
      'allergies': allergies,
    };
    if (isModifiable == true) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          MediumOutlineButton(
            buttonText: 'Customize',
            buttonColor: Colors.white,
            onPressed: () {
              StandardIngredients(ref: ref).add();
              close();
            },
          ),
          MediumElevatedButton(
            buttonText: editOrder ? 'Update' : 'Add to cart',
            onPressed: () {
              editOrder
                  ? editItemInCart(ref, currentItem)
                  : addToCart(ref, currentItem);
              addCost(ref);
              Navigator.pop(context);
            },
          ),
        ],
      );
    } else {
      return LargeElevatedButton(
        buttonText: editOrder ? 'Update' : 'Add to cart',
        onPressed: () {
          editOrder
              ? editItemInCart(ref, currentItem)
              : addToCart(ref, currentItem);
          addCost(ref);
          Navigator.pop(context);
        },
      );
    }
  }

  addToCart(WidgetRef ref, Map<String, dynamic> currentItem) {
    ref.read(currentOrderItemsProvider.notifier).addItem(currentItem);
  }

  editItemInCart(WidgetRef ref, Map<String, dynamic> currentItem) {
    ref.read(currentOrderItemsProvider.notifier).editItem(ref, currentItem);
  }

  addCost(WidgetRef ref) {
    final itemQuantity = ref.watch(itemQuantityProvider);
    final daysQuantity = ref.watch(daysQuantityProvider);
    final itemSize = ref.watch(selectedSizeProvider);
    ref.read(currentOrderCostProvider.notifier).addCost({
      'price': product.price[itemSize]['amount'] +
          (Pricing(ref: ref).totalExtraChargeItems() * 100),
      'memberPrice': product.memberPrice[itemSize]['amount'] +
          Pricing(ref: ref).totalExtraChargeItemsMembers(),
      'itemQuantity': itemQuantity,
      'daysQuantity': daysQuantity,
    });
    ref.invalidate(itemQuantityProvider);
    ref.invalidate(selectedIngredientsProvider);
    ref.invalidate(daysQuantityProvider);
    ref.invalidate(selectedSizeProvider);
    ref.invalidate(editOrderProvider);
    ref.invalidate(productHasToppingsProvider);
    ref.invalidate(selectedToppingsProvider);
    ref.invalidate(selectedAllergiesProvider);
  }
}
