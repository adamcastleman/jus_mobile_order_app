import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/points.dart';
import 'package:jus_mobile_order_app/Helpers/pricing.dart';
import 'package:jus_mobile_order_app/Models/points_details_model.dart';
import 'package:jus_mobile_order_app/Models/product_model.dart';
import 'package:jus_mobile_order_app/Providers/product_providers.dart';

class ProductHelpers {
  final WidgetRef ref;

  ProductHelpers({required this.ref});

  currentItem(ProductModel product, PointsDetailsModel points) {
    final standardIngredients = ref.watch(standardIngredientsProvider);
    final selectedIngredients = ref.watch(selectedIngredientsProvider);
    final itemQuantity = ref.watch(itemQuantityProvider);
    final daysQuantity = ref.watch(daysQuantityProvider);
    final itemSize = ref.watch(itemSizeProvider);
    final hasToppings = ref.watch(productHasToppingsProvider);
    final selectedToppings = ref.watch(selectedToppingsProvider);
    final allergies = ref.watch(selectedAllergiesProvider);
    return {
      'productID': product.productID,
      'isScheduled': product.isScheduled,
      'isModifiable': product.isModifiable,
      'itemQuantity': itemQuantity,
      'daysQuantity': daysQuantity,
      'itemSize': itemSize,
      'itemKey': ref.watch(itemKeyProvider),
      'points': PointsHelper(ref: ref)
          .getPointValue(product.productID, points.rewardsAmounts),
      'hasToppings': hasToppings,
      'selectedIngredients': selectedIngredients,
      'standardIngredients': standardIngredients,
      'selectedToppings': selectedToppings,
      'allergies': allergies,
    };
  }

  addToCart(
    ProductModel product,
    PointsDetailsModel points,
  ) {
    ref
        .read(currentOrderItemsProvider.notifier)
        .addItem(currentItem(product, points));
  }

  editItemInCart(
    ProductModel product,
    PointsDetailsModel points,
  ) {
    ref
        .read(currentOrderItemsProvider.notifier)
        .editItem(ref, currentItem(product, points));
  }

  addCost(ProductModel product, PointsDetailsModel points) {
    final itemQuantity = ref.watch(itemQuantityProvider);
    final daysQuantity = ref.watch(daysQuantityProvider);
    final itemSize = ref.watch(itemSizeProvider);

    ref.read(currentOrderCostProvider.notifier).addCost({
      'price': product.price[itemSize]['amount'] +
          (Pricing(ref: ref).totalCostForExtraChargeIngredientsForNonMembers() *
              100),
      'memberPrice': product.memberPrice[itemSize]['amount'] +
          Pricing(ref: ref).totalCostForExtraChargeIngredientsForMembers(),
      'points': PointsHelper(ref: ref)
          .getPointValue(product.productID, points.rewardsAmounts),
      'productID': product.productID,
      'itemKey': ref.watch(itemKeyProvider),
      'itemQuantity': itemQuantity,
      'daysQuantity': daysQuantity,
    });

    ref.invalidate(itemQuantityProvider);
    ref.invalidate(selectedIngredientsProvider);
    ref.invalidate(daysQuantityProvider);
    ref.invalidate(itemSizeProvider);
    ref.invalidate(editOrderProvider);
    ref.invalidate(productHasToppingsProvider);
    ref.invalidate(selectedToppingsProvider);
    ref.invalidate(selectedAllergiesProvider);
    ref.invalidate(itemKeyProvider);
    ref.invalidate(selectedProductIDProvider);
  }
}
