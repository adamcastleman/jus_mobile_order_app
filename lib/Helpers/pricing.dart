import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:jus_mobile_order_app/Helpers/enums.dart';
import 'package:jus_mobile_order_app/Helpers/locations.dart';
import 'package:jus_mobile_order_app/Models/user_model.dart';
import 'package:jus_mobile_order_app/Providers/discounts_provider.dart';
import 'package:jus_mobile_order_app/Providers/order_providers.dart';
import 'package:jus_mobile_order_app/Providers/product_providers.dart';
import 'package:jus_mobile_order_app/constants.dart';

import '../Models/product_model.dart';

class PricingHelpers {
  double productDetailPriceNonMember(
    WidgetRef ref,
    ProductModel product,
  ) {
    final selectedSize = ref.watch(itemSizeProvider);
    final scheduledQuantity = ref.watch(scheduledQuantityProvider);
    final nonMemberItems = product.variations
        .where(
          (element) => element['customerType'] == AppConstants.nonMemberType,
        )
        .toList();
    final amount = nonMemberItems[selectedSize]['amount'];

    return (amount / 100 +
            totalCostForExtraChargeIngredientsForNonMembers(ref)) *
        scheduledQuantity;
  }

  double productDetailPriceForMembers(
    WidgetRef ref,
    ProductModel product,
  ) {
    final selectedSize = ref.watch(itemSizeProvider);
    final scheduledQuantity = ref.watch(scheduledQuantityProvider);
    final memberItems = product.variations
        .where(
          (element) => element['customerType'] == AppConstants.memberType,
        )
        .toList();
    final amount = memberItems[selectedSize]['amount'];

    return (amount / 100 + totalCostForExtraChargeIngredientsForMembers(ref)) *
        scheduledQuantity;
  }

  String orderTileProductPriceForNonMembers(
      WidgetRef ref, ProductModel currentProduct, int index) {
    final currentOrder = ref.watch(currentOrderItemsProvider);
    final nonMemberVariations = currentProduct.variations
        .where(
            (element) => element['customerType'] == AppConstants.nonMemberType)
        .toList();
    final amount =
        nonMemberVariations[currentOrder[index]['itemSize']]['amount'];

    double price = amount / 100 +
        extraChargeIngredientOnSingleItemForNonMembers(
            currentOrder[index]['selectedIngredients']);
    price *= currentOrder[index]['scheduledQuantity'];
    String priceString = price.toStringAsFixed(2);
    String unit = currentOrder[index]['itemQuantity'] > 1 ? '/ea' : '';
    return '\$$priceString$unit';
  }

  String orderTileProductPriceForMembers(
      WidgetRef ref, ProductModel currentProduct, int index) {
    final currentOrder = ref.watch(currentOrderItemsProvider);
    final memberVariations = currentProduct.variations
        .where((element) => element['customerType'] == AppConstants.memberType)
        .toList();
    final amount = memberVariations[currentOrder[index]['itemSize']]['amount'];

    double price = (amount / 100 +
            extraChargeIngredientOnSingleItemForMembers(
                currentOrder[index]['selectedIngredients'])) *
        currentOrder[index]['scheduledQuantity'];
    return '\$${price.toStringAsFixed(2)}${currentOrder[index]['itemQuantity'] > 1 ? '/ea' : ''}';
  }

  double extraChargeIngredientOnSingleItemForNonMembers(
      List<dynamic> selectedIngredients) {
    if (selectedIngredients.isNotEmpty) {
      return selectedIngredients.fold(0.0, (double total, ingredient) {
            if (ingredient.isNotEmpty) {
              double price =
                  double.tryParse(ingredient['price'].toString()) ?? 0.0;
              double quantity =
                  double.tryParse(ingredient['amount'].toString()) ??
                      1.0; // Correctly handle as double
              int blended = ingredient['blended'] ?? 0;
              int topping = ingredient['topping'] ?? 0;
              int modifierMultiplier =
                  (blended + topping > 0) ? (blended + topping) : 1;
              return total + (price * quantity * modifierMultiplier);
            }
            return total;
          }) /
          100; // Convert to dollars
    }
    return 0.0;
  }

  double extraChargeIngredientOnSingleItemForMembers(
      List<dynamic> selectedIngredients) {
    if (selectedIngredients.isEmpty) {
      return 0.0;
    }

    return selectedIngredients.fold(0.0, (double total, ingredient) {
          if (ingredient.isNotEmpty) {
            double memberPrice =
                double.tryParse(ingredient['memberPrice'].toString()) ?? 0.0;
            double quantity =
                double.tryParse(ingredient['amount'].toString()) ??
                    1.0; // Now parsing as double
            int blended = ingredient['blended'] ?? 0;
            int topping = ingredient['topping'] ?? 0;
            int modifierMultiplier =
                (blended + topping > 0) ? (blended + topping) : 1;
            return total + (memberPrice * quantity * modifierMultiplier);
          }
          return total;
        }) /
        100; // Convert to dollars
  }

  double individualProductSavingsForMembers(
      WidgetRef ref, ProductModel product) {
    final quantity = ref.watch(itemQuantityProvider);
    final scheduledQuantity = ref.watch(scheduledQuantityProvider);
    final selectedSize = ref.watch(itemSizeProvider);
    final memberItems = product.variations
        .where(
          (element) => element['customerType'] == AppConstants.memberType,
        )
        .toList();
    final nonMemberItems = product.variations
        .where(
          (element) => element['customerType'] == AppConstants.nonMemberType,
        )
        .toList();
    final nonMemberAmount = nonMemberItems[selectedSize]['amount'];
    final memberAmount = memberItems[selectedSize]['amount'];

    return (nonMemberAmount / 100 +
            totalCostForExtraChargeIngredientsForNonMembers(ref) -
            memberAmount / 100 +
            totalCostForExtraChargeIngredientsForMembers(ref)) *
        quantity *
        scheduledQuantity;
  }

  double totalCostForExtraChargeIngredientsForNonMembers(WidgetRef ref) {
    final selectedIngredients = ref.watch(selectedIngredientsProvider);
    if (selectedIngredients.isEmpty) {
      return 0.0;
    }

    double total = selectedIngredients.fold(0.0, (double acc, ingredient) {
      if (ingredient.isNotEmpty) {
        int blended = ingredient['blended'] ?? 0;
        int topping = ingredient['topping'] ?? 0;
        double quantity = double.tryParse(ingredient['amount'].toString()) ??
            1.0; // Handle double values correctly
        double pricePerUnit =
            double.tryParse(ingredient['price'].toString()) ?? 0.0;
        int modifierMultiplier =
            (blended + topping > 0) ? (blended + topping) : 1;
        return acc +
            (pricePerUnit *
                quantity *
                modifierMultiplier); // Ensure all operands are of type double
      }
      return acc;
    });

    return total /
        100; // Total is stored in cents, needs to be returned in dollars
  }

  double totalCostForExtraChargeIngredientsForMembers(WidgetRef ref) {
    final selectedIngredients = ref.watch(selectedIngredientsProvider);

    if (selectedIngredients.isEmpty) {
      return 0.0;
    }

    double total = selectedIngredients.fold(0.0, (double acc, ingredient) {
      if (ingredient.isNotEmpty) {
        double memberPrice =
            double.tryParse(ingredient['memberPrice'].toString()) ?? 0.0;
        double quantity = double.tryParse(ingredient['amount'].toString()) ??
            1.0; // Handle double for quantity
        int blended = ingredient['blended'] ?? 0;
        int topping = ingredient['topping'] ?? 0;
        int modifierMultiplier =
            (blended + topping > 0) ? (blended + topping) : 1;
        return acc +
            (memberPrice *
                quantity *
                modifierMultiplier); // Ensure all operations are with doubles
      }
      return acc;
    });

    return total /
        100; // Total is stored in cents, needs to be returned in dollars
  }

  double discountTotalForNonMembers(WidgetRef ref) {
    final discount = ref.watch(discountTotalProvider);
    double total = 0.0;
    for (var amount in discount) {
      total = total + amount['price'];
    }

    return total / 100;
  }

  double discountTotalForMembers(WidgetRef ref) {
    final discount = ref.watch(discountTotalProvider);

    double total = 0.0;
    for (var amount in discount) {
      total = total + amount['memberPrice'];
    }
    return total / 100;
  }

  double tipAmountForNonMembers(WidgetRef ref) {
    final tipPercentage = ref.watch(selectedTipPercentageProvider);

    return originalSubtotalForNonMembers(ref) * (tipPercentage / 100);
  }

  double tipAmountForMembers(WidgetRef ref) {
    final tipPercentage = ref.watch(selectedTipPercentageProvider);

    return originalSubtotalForMembers(ref) * (tipPercentage / 100);
  }

  double originalSubtotalForNonMembers(WidgetRef ref) {
    var subtotal = 0.0;
    final totalCost = ref.watch(currentOrderCostProvider);
    for (var price in totalCost) {
      var totalItemPrice =
          price['itemPriceNonMember'] + (price['modifierPriceNonMember'] ?? 0);

      subtotal = subtotal + totalItemPrice;
    }

    return subtotal / 100;
  }

  originalSubtotalForMembers(WidgetRef ref) {
    var subtotal = 0.0;
    final totalCost = ref.watch(currentOrderCostProvider);
    for (var price in totalCost) {
      var totalItemPrice =
          price['itemPriceMember'] + (price['modifierPriceMember'] ?? 0);
      subtotal = subtotal + totalItemPrice;
    }

    return subtotal / 100;
  }

  double discountedSubtotalForNonMembers(WidgetRef ref) {
    double original = originalSubtotalForNonMembers(ref);
    double discount = discountTotalForNonMembers(ref);

    return (original - discount);
  }

  double discountedSubtotalForMembers(WidgetRef ref) {
    double original = originalSubtotalForMembers(ref);
    double discount = discountTotalForMembers(ref);

    return (original - discount);
  }

  double totalTaxForNonMembers(WidgetRef ref) {
    final selectedLocation = LocationHelper().selectedLocation(ref);
    final price = originalSubtotalForNonMembers(ref);
    final discount = discountTotalForNonMembers(ref);
    final taxRate = selectedLocation?.salesTaxRate ?? 0;
    return (price - discount) * taxRate;
  }

  double totalTaxForMembers(WidgetRef ref) {
    final selectedLocation = LocationHelper().selectedLocation(ref);
    final price = originalSubtotalForMembers(ref);
    final discount = discountTotalForMembers(ref);
    final taxRate = selectedLocation?.salesTaxRate ?? 0;
    return (price - discount) * taxRate;
  }

  double orderTotalForNonMembers(WidgetRef ref) {
    final subtotal = originalSubtotalForNonMembers(ref);
    final tax = totalTaxForNonMembers(ref);
    return subtotal -
        discountTotalForNonMembers(ref) +
        tax +
        tipAmountForNonMembers(ref);
  }

  double orderTotalForMembers(WidgetRef ref) {
    final subtotal = originalSubtotalForMembers(ref);
    final tax = totalTaxForMembers(ref);

    return subtotal -
        discountTotalForMembers(ref) +
        tax +
        tipAmountForMembers(ref);
  }

  double orderTotalFromUserType(WidgetRef ref, UserModel user) {
    if (user.uid == null || user.subscriptionStatus!.isNotActive) {
      return orderTotalForNonMembers(ref) * 100;
    } else {
      return PricingHelpers().orderTotalForMembers(ref) * 100;
    }
  }

  double totalOrderSavings(WidgetRef ref) {
    return orderTotalForNonMembers(ref) - orderTotalForMembers(ref);
  }

  bool isZeroCharge(WidgetRef ref) {
    if (originalSubtotalForNonMembers(ref) + tipAmountForNonMembers(ref) ==
        discountTotalForNonMembers(ref)) {
      return true;
    } else {
      return false;
    }
  }

  static String formatAsCurrency(double amount) {
    return NumberFormat('#,##0.00').format(amount);
  }
}
