import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Models/product_model.dart';
import 'package:jus_mobile_order_app/Providers/product_providers.dart';
import 'package:jus_mobile_order_app/Providers/theme_providers.dart';
import 'package:jus_mobile_order_app/Widgets/Helpers/spacing_widgets.dart';

class OrderTileEditRow extends ConsumerWidget {
  final int index;
  final ProductModel currentProduct;
  final Function close;
  const OrderTileEditRow(
      {required this.index,
      required this.currentProduct,
      required this.close,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final backgroundColor = ref.watch(themeColorProvider);
    final currentOrder = ref.watch(currentOrderItemsProvider);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        currentProduct.isScheduled
            ? const SizedBox()
            : Row(
                children: [
                  InkWell(
                    onTap: () {
                      removeSingleQuantityCost(ref);
                      removeSingleQuantityItem(ref);
                    },
                    child: const Icon(CupertinoIcons.minus_circled),
                  ),
                  Spacing().horizontal(5),
                  InkWell(
                    onTap: () {
                      addSingleQuantityCost(ref, currentProduct);
                      addSingleQuantityItem(ref);
                    },
                    child: const Icon(CupertinoIcons.add_circled),
                  ),
                  Spacing().horizontal(12),
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    child: Text(
                      '${currentOrder[index]['itemQuantity']}x',
                      style: const TextStyle(fontSize: 11),
                    ),
                  ),
                ],
              ),
        Row(
          children: [
            !currentProduct.isScheduled &&
                    (!currentProduct.isModifiable &&
                        !currentProduct.hasToppings)
                ? const SizedBox()
                : Padding(
                    padding: const EdgeInsets.only(right: 12.0),
                    child: InkWell(
                      onTap: () {
                        HapticFeedback.lightImpact();
                        setItemVariation(ref);
                        setItemIndex(ref);
                        removeCostFromTotal(ref);
                        close();
                      },
                      child: CircleAvatar(
                        radius: 16,
                        backgroundColor: Colors.black,
                        child: CircleAvatar(
                          radius: 15.5,
                          backgroundColor: backgroundColor!,
                          child: const Icon(
                            FontAwesomeIcons.pencil,
                            color: Colors.black,
                            size: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
            InkWell(
              onTap: () {
                setItemIndex(ref);
                removeCostFromTotal(ref);
                removeItemFromCart(ref);
              },
              child: CircleAvatar(
                radius: 16,
                backgroundColor: Colors.black,
                child: CircleAvatar(
                  radius: 15.5,
                  backgroundColor: backgroundColor!,
                  child: const Icon(
                    CupertinoIcons.trash,
                    color: Colors.black,
                    size: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  addSingleQuantityCost(WidgetRef ref, ProductModel currentProduct) {
    final currentOrder = ref.watch(currentOrderItemsProvider);
    double extraCharge = 0.0;
    double extraChargeMembers = 0.0;
    for (var item in currentOrder[index]['selectedIngredients']) {
      extraCharge = extraCharge + double.parse(item['price']);
      extraChargeMembers =
          extraChargeMembers + double.parse(item['memberPrice']);
    }
    return ref.read(currentOrderCostProvider.notifier).addCost({
      'price': currentProduct.price[currentOrder[index]['itemSize']]['amount'] +
          extraCharge,
      'memberPrice': currentProduct.memberPrice[currentOrder[index]['itemSize']]
              ['amount'] +
          extraChargeMembers,
      'itemQuantity': 1,
      'daysQuantity': currentOrder[index]['daysQuantity'],
    });
  }

  removeSingleQuantityCost(WidgetRef ref) {
    final currentOrder = ref.watch(currentOrderItemsProvider);
    double extraCharge = 0.0;
    double extraChargeMembers = 0.0;
    for (var item in currentOrder[index]['selectedIngredients']) {
      extraCharge = extraCharge + double.parse(item['price']);
      extraChargeMembers =
          extraChargeMembers + double.parse(item['memberPrice']);
    }
    if (currentOrder[index]['itemQuantity'] == 1) {
      return null;
    } else {
      return ref.read(currentOrderCostProvider.notifier).removeCost(
            nonMemberTotal: currentProduct
                    .price[currentOrder[index]['itemSize']]['amount'] +
                extraCharge,
            memberTotal: currentProduct
                    .memberPrice[currentOrder[index]['itemSize']]['amount'] +
                extraChargeMembers,
          );
    }
  }

  addSingleQuantityItem(WidgetRef ref) {
    return ref
        .read(currentOrderItemsProvider.notifier)
        .addItemQuantity(currentProduct, index);
  }

  removeSingleQuantityItem(WidgetRef ref) {
    return ref
        .read(currentOrderItemsProvider.notifier)
        .removeItemQuantity(currentProduct, index);
  }

  removeCostToEditItem(WidgetRef ref) {
    ref.read(currentOrderCostProvider.notifier).removeCost(
        nonMemberTotal: nonMemberCostTotal(ref),
        memberTotal: memberCostTotal(ref));
  }

  setItemVariation(WidgetRef ref) {
    final currentOrder = ref.watch(currentOrderItemsProvider);
    var ingredients = currentOrder[index]['selectedIngredients'].isEmpty
        ? currentOrder[index]['standardIngredients']
        : currentOrder[index]['selectedIngredients'];
    ref
        .read(itemQuantityProvider.notifier)
        .set(currentOrder[index]['itemQuantity']);
    ref
        .read(daysQuantityProvider.notifier)
        .set(currentOrder[index]['daysQuantity']);
    ref.read(selectedSizeProvider.notifier).state =
        currentOrder[index]['itemSize'];
    ref.read(productHasToppingsProvider.notifier).state =
        currentOrder[index]['hasToppings'];
    ref
        .read(selectedToppingsProvider.notifier)
        .addMultipleToppings(currentOrder[index]['selectedToppings']);
    ref
        .read(selectedAllergiesProvider.notifier)
        .addListOfAllergies(currentOrder[index]['allergies']);
    ref.read(editOrderProvider.notifier).state = true;
    ref.read(selectedIngredientsProvider.notifier).addIngredients(ingredients);
  }

  setItemIndex(WidgetRef ref) {
    ref.read(currentOrderItemsIndexProvider.notifier).state = index;
  }

  removeItemFromCart(WidgetRef ref) {
    return ref.read(currentOrderItemsProvider.notifier).removeItem(ref);
  }

  removeCostFromTotal(WidgetRef ref) {
    ref.read(currentOrderCostProvider.notifier).removeCost(
        nonMemberTotal: nonMemberCostTotal(ref),
        memberTotal: memberCostTotal(ref));
  }

  nonMemberCostTotal(WidgetRef ref) {
    final currentOrderItem = ref.watch(currentOrderItemsProvider);
    double extraCharge = 0.0;
    for (var item in currentOrderItem[index]['selectedIngredients']) {
      extraCharge = extraCharge + double.parse(item['price']);
    }
    final price =
        currentProduct.price[currentOrderItem[index]['itemSize']]['amount'];
    final itemQuantity = currentOrderItem[index]['itemQuantity'];
    final daysQuantity = currentOrderItem[index]['daysQuantity'];
    return (price + extraCharge) * itemQuantity * daysQuantity;
  }

  memberCostTotal(WidgetRef ref) {
    final currentOrderItem = ref.watch(currentOrderItemsProvider);
    double extraCharge = 0.0;
    for (var item in currentOrderItem[index]['selectedIngredients']) {
      extraCharge = extraCharge + double.parse(item['memberPrice']);
    }
    final price = currentProduct
        .memberPrice[currentOrderItem[index]['itemSize']]['amount'];
    final itemQuantity = currentOrderItem[index]['itemQuantity'];
    final daysQuantity = currentOrderItem[index]['daysQuantity'];
    return price * itemQuantity * daysQuantity;
  }
}
