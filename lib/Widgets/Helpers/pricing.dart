import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Providers/product_providers.dart';
import 'package:jus_mobile_order_app/Widgets/Helpers/locations.dart';

import '../../Models/product_model.dart';

class Pricing {
  WidgetRef? ref;

  Pricing({this.ref});

  productPrice(ProductModel currentProduct, int index) {
    final currentOrder = ref!.watch(currentOrderItemsProvider);
    return '\$${((currentProduct.price[currentOrder[index]['itemSize']]['amount'] / 100 + Pricing().ingredientExtraCharge(currentOrder[index]['selectedIngredients'])) * currentOrder[index]['daysQuantity']).toStringAsFixed(2)}${currentOrder[index]['itemQuantity'] > 1 ? '/ea' : ''}';
  }

  productPriceMembers(ProductModel currentProduct, int index) {
    final currentOrder = ref!.watch(currentOrderItemsProvider);
    return '\$${(((currentProduct.memberPrice[currentOrder[index]['itemSize']]['amount']) / 100 + Pricing().ingredientExtraChargeMembers(currentOrder[index]['selectedIngredients'])) * currentOrder[index]['daysQuantity']).toStringAsFixed(2)}${currentOrder[index]['itemQuantity'] > 1 ? '/ea' : ''}';
  }

  ingredientExtraCharge(List<dynamic> selectedIngredients) {
    double total = 0;
    for (var ingredient in selectedIngredients) {
      ingredient.isEmpty
          ? total = total
          : total = total + double.parse(ingredient['price']);
    }

    return total / 100;
  }

  ingredientExtraChargeMembers(List<dynamic> selectedIngredients) {
    double total = 0;
    for (var ingredient in selectedIngredients) {
      ingredient.isEmpty
          ? total = total
          : total = total + double.parse(ingredient['memberPrice']);
    }
    return total / 100;
  }

  productSavings(ProductModel product) {
    final quantity = ref!.watch(itemQuantityProvider);
    final daysQuantity = ref!.watch(daysQuantityProvider);
    final selectedSize = ref!.watch(selectedSizeProvider);
    return (((product.price[selectedSize]['amount'] / 100) +
                Pricing(ref: ref).totalExtraChargeItems() -
                (product.memberPrice[selectedSize]['amount'] / 100) +
                Pricing(ref: ref).totalExtraChargeItemsMembers()) *
            quantity *
            daysQuantity)
        .toStringAsFixed(2);
  }

  totalExtraChargeItems() {
    final selectedIngredients = ref!.watch(selectedIngredientsProvider);

    double total = 0;

    for (var item in selectedIngredients) {
      item.isEmpty
          ? total = total
          : total = total + double.parse((item['price']).toString());
    }

    return total / 100;
  }

  totalExtraChargeItemsMembers() {
    final selectedIngredients = ref!.watch(selectedIngredientsProvider);
    double total = 0;
    for (var item in selectedIngredients) {
      item.isEmpty
          ? total = total
          : total = total + double.parse((item['memberPrice']).toString());
    }
    return total / 100;
  }

  orderSubtotal(WidgetRef ref) {
    final price = ref.watch(currentOrderCostProvider);

    return (price['nonMember'] / 100);
  }

  orderSubtotalMember(WidgetRef ref) {
    final price = ref.watch(currentOrderCostProvider);
    return (price['member'] / 100);
  }

  orderTax(WidgetRef ref) {
    final selectedLocation = LocationHelper().selectedLocation(ref);
    final price = ref.watch(currentOrderCostProvider);
    final taxRate =
        selectedLocation == null ? 0 : selectedLocation.salesTaxRate;
    return ((price['nonMember'] * taxRate) / 100);
  }

  orderTaxMember(WidgetRef ref) {
    final selectedLocation = LocationHelper().selectedLocation(ref);
    final price = ref.watch(currentOrderCostProvider);
    final taxRate =
        selectedLocation == null ? 0 : selectedLocation.salesTaxRate;
    return ((price['member'] * taxRate) / 100);
  }

  orderTotal(WidgetRef ref) {
    return ((orderSubtotal(ref)) + orderTax(ref));
  }

  orderTotalMember(WidgetRef ref) {
    return (orderSubtotalMember(ref) + orderTaxMember(ref));
  }

  totalSavings(WidgetRef ref) {
    return (orderTotal(ref) - orderTotalMember(ref));
  }
}
