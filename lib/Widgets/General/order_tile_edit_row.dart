import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/error.dart';
import 'package:jus_mobile_order_app/Helpers/loading.dart';
import 'package:jus_mobile_order_app/Helpers/points.dart';
import 'package:jus_mobile_order_app/Helpers/set_standard_ingredients.dart';
import 'package:jus_mobile_order_app/Models/points_details_model.dart';
import 'package:jus_mobile_order_app/Models/product_model.dart';
import 'package:jus_mobile_order_app/Providers/product_providers.dart';
import 'package:jus_mobile_order_app/Providers/stream_providers.dart';
import 'package:jus_mobile_order_app/Providers/theme_providers.dart';
import 'package:jus_mobile_order_app/Widgets/General/selection_incrementor.dart';

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
    final backgroundColor = ref.watch(backgroundColorProvider);
    final currentOrder = ref.watch(currentOrderItemsProvider);
    final pointsDetails = ref.watch(pointsDetailsProvider);
    return pointsDetails.when(
      error: (e, _) => ShowError(error: e.toString()),
      loading: () => const Loading(),
      data: (points) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          currentProduct.isScheduled
              ? const SizedBox()
              : SelectionIncrementer(
                  verticalPadding: 0,
                  horizontalPadding: 0,
                  buttonSpacing: 10,
                  iconSize: 22,
                  quantityRadius: 15,
                  quantity: '${currentOrder[index]['itemQuantity']}x',
                  onAdd: () {
                    addSingleQuantityCost(ref, currentProduct, points);
                    addSingleQuantityItem(ref);
                  },
                  onRemove: () {
                    removeSingleQuantityCost(ref);
                    removeSingleQuantityItem(ref);
                  },
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
                          setItemIndex(ref);
                          setItemVariation(ref);

                          removeCostFromTotal(ref);
                          close();
                        },
                        child: CircleAvatar(
                          radius: 16,
                          backgroundColor: Colors.black,
                          child: CircleAvatar(
                            radius: 15.5,
                            backgroundColor: backgroundColor,
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
                    backgroundColor: backgroundColor,
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
      ),
    );
  }

  addSingleQuantityCost(
      WidgetRef ref, ProductModel currentProduct, PointsDetailsModel points) {
    final currentOrder = ref.watch(currentOrderItemsProvider);
    final extraCharge = currentOrder[index]['selectedIngredients']
        .fold(0, (sum, item) => sum + double.tryParse(item['price'] ?? 0.0));
    final extraChargeMembers = currentOrder[index]['selectedIngredients'].fold(
        0, (sum, item) => sum + double.tryParse(item['memberPrice'] ?? 0.0));

    return ref.read(currentOrderCostProvider.notifier).addCost({
      'price': currentProduct.price[currentOrder[index]['itemSize']]['amount'] +
          extraCharge,
      'points': PointsHelper(ref: ref)
          .getPointValue(currentProduct.productID, points.rewardsAmounts),
      'itemKey': currentOrder[index]['itemKey'],
      'productID': currentOrder[index]['productID'],
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
    for (var item in currentOrder[index]['selectedIngredients'] ?? []) {
      extraCharge = extraCharge + double.parse(item['price'] ?? 0.0);
      extraChargeMembers =
          extraChargeMembers + double.parse(item['memberPrice'] ?? 0.0);
    }
    if (currentOrder[index]['itemQuantity'] == 1) {
      return null;
    } else {
      return ref
          .read(currentOrderCostProvider.notifier)
          .removeSingleCost(currentOrder[index]['itemKey']);
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

  setItemVariation(WidgetRef ref) {
    final currentOrder = ref.watch(currentOrderItemsProvider);
    var ingredients = [];
    if (currentOrder[index]['isModifiable'] != true ||
        currentOrder[index]['isScheduled'] == true) {
      ingredients = [];
    } else {
      ingredients = currentOrder[index]['selectedIngredients'].isEmpty
          ? []
          : currentOrder[index]['selectedIngredients'];
    }
    ref.read(selectedIngredientsProvider.notifier).addIngredients(ingredients);
    StandardIngredients(ref: ref).set(currentProduct);
    ref
        .read(itemQuantityProvider.notifier)
        .set(currentOrder[index]['itemQuantity']);

    ref
        .read(daysQuantityProvider.notifier)
        .set(currentOrder[index]['daysQuantity']);
    ref.read(itemSizeProvider.notifier).state = currentOrder[index]['itemSize'];
    ref.read(productHasToppingsProvider.notifier).state =
        currentOrder[index]['hasToppings'];
    ref
        .read(selectedToppingsProvider.notifier)
        .addMultipleToppings(currentOrder[index]['selectedToppings']);
    ref
        .read(selectedAllergiesProvider.notifier)
        .addListOfAllergies(currentOrder[index]['allergies']);
    ref.read(editOrderProvider.notifier).state = true;
    ref.read(itemKeyProvider.notifier).state = currentOrder[index]['itemKey'];
  }

  setItemIndex(WidgetRef ref) {
    ref.read(currentOrderItemsIndexProvider.notifier).state = index;
  }

  removeItemFromCart(WidgetRef ref) {
    return ref.read(currentOrderItemsProvider.notifier).removeItem(ref);
  }

  removeCostFromTotal(WidgetRef ref) {
    final currentOrder = ref.watch(currentOrderItemsProvider);
    ref
        .read(currentOrderCostProvider.notifier)
        .removeMultipleCost(currentOrder[index]['itemKey']);
  }

  nonMemberCostTotal(WidgetRef ref) {
    final currentOrderItem = ref.watch(currentOrderItemsProvider);
    double extraCharge = 0.0;
    for (var item in currentOrderItem[index]['selectedIngredients']) {
      item.isEmpty
          ? extraCharge = extraCharge
          : extraCharge = extraCharge + double.parse(item['price']);
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
      item.isEmpty
          ? extraCharge = extraCharge
          : extraCharge = extraCharge + double.parse(item['memberPrice']);
    }
    final price = currentProduct
        .memberPrice[currentOrderItem[index]['itemSize']]['amount'];
    final itemQuantity = currentOrderItem[index]['itemQuantity'];
    final daysQuantity = currentOrderItem[index]['daysQuantity'];
    return price * itemQuantity * daysQuantity;
  }
}
