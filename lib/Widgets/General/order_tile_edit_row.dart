import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/locations.dart';
import 'package:jus_mobile_order_app/Helpers/points.dart';
import 'package:jus_mobile_order_app/Helpers/set_standard_ingredients.dart';
import 'package:jus_mobile_order_app/Models/points_details_model.dart';
import 'package:jus_mobile_order_app/Models/product_model.dart';
import 'package:jus_mobile_order_app/Providers/ProviderWidgets/points_details_provider_widget.dart';
import 'package:jus_mobile_order_app/Providers/ProviderWidgets/product_quantity_limit_provider.dart';
import 'package:jus_mobile_order_app/Providers/location_providers.dart';
import 'package:jus_mobile_order_app/Providers/product_providers.dart';
import 'package:jus_mobile_order_app/Providers/theme_providers.dart';
import 'package:jus_mobile_order_app/Widgets/General/selection_incrementor.dart';
import 'package:jus_mobile_order_app/constants.dart';

class OrderTileEditRow extends ConsumerWidget {
  final int index;
  final ProductModel currentProduct;
  final Function close;
  const OrderTileEditRow(
      {required this.index,
      required this.currentProduct,
      required this.close,
      super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final backgroundColor = ref.watch(backgroundColorProvider);
    final currentOrder = ref.watch(currentOrderItemsProvider);
    return ProductQuantityLimitProviderWidget(
      productUID: currentProduct.uid,
      builder: (quantity) => PointsDetailsProviderWidget(
        builder: (points) => Row(
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
                      if (quantity.quantityLimit == 0 ||
                          (quantity.quantityLimit != null &&
                              currentOrder[index]['itemQuantity'] <
                                  quantity.quantityLimit)) {
                        addSingleQuantityCost(ref, currentProduct, points);
                        addSingleQuantityItem(ref);
                      }
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
                          onTap: () => handleEditTap(context, ref),
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
                  onTap: () => handleDeleteTap(ref),
                  child: CircleAvatar(
                    radius: 16,
                    backgroundColor: Colors.red,
                    child: CircleAvatar(
                      radius: 15.5,
                      backgroundColor: backgroundColor,
                      child: const Icon(
                        CupertinoIcons.trash,
                        color: Colors.red,
                        size: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void handleEditTap(
    BuildContext context,
    WidgetRef ref,
  ) {
    if (ref.read(selectedLocationProvider) == null) {
      LocationHelper().chooseLocation(context, ref);
    } else {
      setItemIndex(ref);
      setItemVariation(ref);
      removeCostFromTotal(ref);
      close();
    }
  }

  void handleDeleteTap(WidgetRef ref) {
    setItemIndex(ref);
    removeCostFromTotal(ref);
    removeItemFromCart(ref);
  }

  addSingleQuantityCost(
      WidgetRef ref, ProductModel currentProduct, PointsDetailsModel points) {
    final currentOrder = ref.watch(currentOrderItemsProvider);
    final extraCharge = currentOrder[index]['selectedIngredients']
        .fold(0, (sum, item) => sum + double.tryParse(item['price'] ?? 0.0));
    final extraChargeMembers = currentOrder[index]['selectedIngredients'].fold(
        0, (sum, item) => sum + double.tryParse(item['memberPrice'] ?? 0.0));
    final nonMemberVariations = currentProduct.variations
        .where(
            (element) => element['customerType'] == AppConstants.nonMemberType)
        .toList();
    final memberVariations = currentProduct.variations
        .where((element) => element['customerType'] == AppConstants.memberType)
        .toList();
    final nonMemberAmount =
        nonMemberVariations[currentOrder[index]['itemSize']]['amount'];
    final memberAmount =
        memberVariations[currentOrder[index]['itemSize']]['amount'];

    return ref.read(currentOrderCostProvider.notifier).addCost({
      'itemPriceNonMember': nonMemberAmount + extraCharge,
      'itemPriceMember': memberAmount + extraChargeMembers,
      'points': PointsHelper(ref: ref)
          .getPointValue(currentProduct.productID, points.rewardsAmounts),
      'itemKey': currentOrder[index]['itemKey'],
      'productID': currentOrder[index]['productID'],
      'memberPrice': memberAmount + extraChargeMembers,
      'itemQuantity': 1,
      'scheduledQuantity': currentOrder[index]['scheduledQuantity'],
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
        .read(scheduledQuantityProvider.notifier)
        .set(currentOrder[index]['scheduledQuantity']);
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
    final nonMemberAmount = currentProduct.variations.firstWhere(
            (element) => element['customerType'] == AppConstants.nonMemberType)[
        currentOrderItem[index]['itemSize']]['amount'];

    for (var item in currentOrderItem[index]['selectedIngredients']) {
      item.isEmpty
          ? extraCharge = extraCharge
          : extraCharge = extraCharge + double.parse(item['price']);
    }
    final price = nonMemberAmount;
    final itemQuantity = currentOrderItem[index]['itemQuantity'];
    final scheduledQuantity = currentOrderItem[index]['scheduledQuantity'];
    return (price + extraCharge) * itemQuantity * scheduledQuantity;
  }

  memberCostTotal(WidgetRef ref) {
    final currentOrderItem = ref.watch(currentOrderItemsProvider);
    double extraCharge = 0.0;
    final memberAmount = currentProduct.variations.firstWhere((element) =>
        element['customerType'] ==
        AppConstants.memberType)[currentOrderItem[index]['itemSize']]['amount'];

    for (var item in currentOrderItem[index]['selectedIngredients']) {
      item.isEmpty
          ? extraCharge = extraCharge
          : extraCharge = extraCharge + double.parse(item['memberPrice']);
    }
    final price = memberAmount;
    final itemQuantity = currentOrderItem[index]['itemQuantity'];
    final scheduledQuantity = currentOrderItem[index]['scheduledQuantity'];
    return price * itemQuantity * scheduledQuantity;
  }
}
