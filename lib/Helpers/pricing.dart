import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/locations.dart';
import 'package:jus_mobile_order_app/Models/user_model.dart';
import 'package:jus_mobile_order_app/Providers/discounts_provider.dart';
import 'package:jus_mobile_order_app/Providers/order_providers.dart';
import 'package:jus_mobile_order_app/Providers/product_providers.dart';

import '../Models/product_model.dart';

class Pricing {
  WidgetRef? ref;

  Pricing({this.ref});

  double productDetailPriceNonMember(
    ProductModel product,
  ) {
    final selectedSize = ref!.watch(itemSizeProvider);
    final scheduledQuantity = ref!.watch(scheduledQuantityProvider);

    return (product.price[selectedSize]['amount'] / 100 +
            totalCostForExtraChargeIngredientsForNonMembers()) *
        scheduledQuantity;
  }

  double productDetailPriceForMembers(
    ProductModel product,
  ) {
    final selectedSize = ref!.watch(itemSizeProvider);
    final scheduledQuantity = ref!.watch(scheduledQuantityProvider);

    return (product.memberPrice[selectedSize]['amount'] / 100 +
            totalCostForExtraChargeIngredientsForMembers()) *
        scheduledQuantity;
  }

  String orderTileProductPriceForNonMembers(
      ProductModel currentProduct, int index) {
    final currentOrder = ref!.watch(currentOrderItemsProvider);
    double price =
        currentProduct.price[currentOrder[index]['itemSize']]['amount'] / 100 +
            extraChargeIngredientOnSingleItemForNonMembers(
                currentOrder[index]['selectedIngredients']);
    price *= currentOrder[index]['scheduledQuantity'];
    String priceString = price.toStringAsFixed(2);
    String unit = currentOrder[index]['itemQuantity'] > 1 ? '/ea' : '';
    return '\$$priceString$unit';
  }

  String orderTileProductPriceForMembers(
      ProductModel currentProduct, int index) {
    final currentOrder = ref!.watch(currentOrderItemsProvider);
    double price = (currentProduct.memberPrice[currentOrder[index]['itemSize']]
                    ['amount'] /
                100 +
            extraChargeIngredientOnSingleItemForMembers(
                currentOrder[index]['selectedIngredients'])) *
        currentOrder[index]['scheduledQuantity'];
    return '\$${price.toStringAsFixed(2)}${currentOrder[index]['itemQuantity'] > 1 ? '/ea' : ''}';
  }

  double extraChargeIngredientOnSingleItemForNonMembers(
      List<dynamic> selectedIngredients) {
    if (selectedIngredients.isNotEmpty) {
      return selectedIngredients
              .where((ingredient) => ingredient.isNotEmpty)
              .map((ingredient) => double.parse(ingredient['price']))
              .reduce((a, b) => a + b) /
          100;
    } else {
      return 0.0;
    }
  }

  double extraChargeIngredientOnSingleItemForMembers(
      List<dynamic> selectedIngredients) {
    if (selectedIngredients.isEmpty) {
      return 0.0;
    } else {
      return selectedIngredients.fold(
              0.0,
              (total, ingredient) => ingredient.isEmpty
                  ? total
                  : total + double.parse(ingredient['memberPrice'])) /
          100;
    }
  }

  double individualProductSavingsForMembers(ProductModel product) {
    final quantity = ref!.watch(itemQuantityProvider);
    final scheduledQuantity = ref!.watch(scheduledQuantityProvider);
    final selectedSize = ref!.watch(itemSizeProvider);

    return (product.price[selectedSize]['amount'] / 100 +
            totalCostForExtraChargeIngredientsForNonMembers() -
            product.memberPrice[selectedSize]['amount'] / 100 +
            Pricing(ref: ref).totalCostForExtraChargeIngredientsForMembers()) *
        quantity *
        scheduledQuantity;
  }

  double totalCostForExtraChargeIngredientsForNonMembers() {
    final selectedIngredients = ref!.watch(selectedIngredientsProvider);
    if (selectedIngredients.isEmpty) {
      return 0.0;
    }
    return selectedIngredients
            .where((ingredient) => ingredient.isNotEmpty)
            .map((ingredient) => double.parse(ingredient['price']))
            .reduce((a, b) => a + b) /
        100;
  }

  double totalCostForExtraChargeIngredientsForMembers() {
    final selectedIngredients = ref!.watch(selectedIngredientsProvider);

    if (selectedIngredients.isEmpty) {
      return 0.0;
    }

    return selectedIngredients
            .where((ingredient) => ingredient.isNotEmpty)
            .map((ingredient) => double.parse(ingredient['memberPrice']))
            .reduce((a, b) => a + b) /
        100;
  }

  double discountTotalForNonMembers() {
    final discount = ref!.watch(discountTotalProvider);
    double total = 0.0;
    for (var amount in discount) {
      total = total + amount['price'];
    }

    return total / 100;
  }

  double discountTotalForMembers() {
    final discount = ref!.watch(discountTotalProvider);

    double total = 0.0;
    for (var amount in discount) {
      total = total + amount['memberPrice'];
    }
    return total / 100;
  }

  double tipAmountForNonMembers() {
    final tipPercentage = ref!.watch(selectedTipPercentageProvider);

    return originalSubtotalForNonMembers() * (tipPercentage / 100);
  }

  double tipAmountForMembers() {
    final tipPercentage = ref!.watch(selectedTipPercentageProvider);

    return originalSubtotalForMembers() * (tipPercentage / 100);
  }

  double originalSubtotalForNonMembers() {
    var subtotal = 0.0;
    final totalCost = ref!.watch(currentOrderCostProvider);
    for (var price in totalCost) {
      subtotal = subtotal + price['price'];
    }

    return subtotal / 100;
  }

  originalSubtotalForMembers() {
    var subtotal = 0.0;
    final totalCost = ref!.watch(currentOrderCostProvider);
    for (var price in totalCost) {
      subtotal = subtotal + price['memberPrice'];
    }

    return subtotal / 100;
  }

  double discountedSubtotalForNonMembers() {
    double original = originalSubtotalForNonMembers();
    double discount = discountTotalForNonMembers();

    return (original - discount);
  }

  double discountedSubtotalForMembers() {
    double original = originalSubtotalForMembers();
    double discount = discountTotalForMembers();

    return (original - discount);
  }

  double totalTaxForNonMembers() {
    final selectedLocation = LocationHelper().selectedLocation(ref!);
    final price = originalSubtotalForNonMembers();
    final discount = discountTotalForNonMembers();
    final taxRate = selectedLocation?.salesTaxRate ?? 0;
    return (price - discount) * taxRate;
  }

  double totalTaxForMembers() {
    final selectedLocation = LocationHelper().selectedLocation(ref!);
    final price = originalSubtotalForMembers();
    final discount = discountTotalForMembers();
    final taxRate = selectedLocation?.salesTaxRate ?? 0;
    return (price - discount) * taxRate;
  }

  double orderTotalForNonMembers() {
    final subtotal = originalSubtotalForNonMembers();
    final tax = totalTaxForNonMembers();
    return subtotal -
        discountTotalForNonMembers() +
        tax +
        tipAmountForNonMembers();
  }

  double orderTotalForMembers() {
    final subtotal = originalSubtotalForMembers();
    final tax = totalTaxForMembers();

    return subtotal - discountTotalForMembers() + tax + tipAmountForMembers();
  }

  double orderTotalFromUserType(UserModel user) {
    if (user.uid == null || !user.isActiveMember!) {
      return orderTotalForNonMembers() * 100;
    } else {
      return Pricing(ref: ref).orderTotalForMembers() * 100;
    }
  }

  double totalOrderSavings() {
    return orderTotalForNonMembers() - orderTotalForMembers();
  }

  bool isZeroCharge() {
    if (originalSubtotalForNonMembers() + tipAmountForNonMembers() ==
        discountTotalForNonMembers()) {
      return true;
    } else {
      return false;
    }
  }
}
