import 'package:collection/collection.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/enums.dart';
import 'package:jus_mobile_order_app/Helpers/formulas.dart';
import 'package:jus_mobile_order_app/Helpers/points.dart';
import 'package:jus_mobile_order_app/Helpers/pricing.dart';
import 'package:jus_mobile_order_app/Helpers/set_standard_ingredients.dart';
import 'package:jus_mobile_order_app/Helpers/set_standard_items.dart';
import 'package:jus_mobile_order_app/Models/favorites_model.dart';
import 'package:jus_mobile_order_app/Models/ingredient_model.dart';
import 'package:jus_mobile_order_app/Models/points_details_model.dart';
import 'package:jus_mobile_order_app/Models/product_model.dart';
import 'package:jus_mobile_order_app/Models/user_model.dart';
import 'package:jus_mobile_order_app/Providers/product_providers.dart';
import 'package:jus_mobile_order_app/Providers/stream_providers.dart';
import 'package:jus_mobile_order_app/constants.dart';

class ProductHelpers {
  ProductHelpers();

  setProductProviders(WidgetRef ref, ProductModel product) {
    ref.read(selectedProductIdProvider.notifier).state = product.productId;
    ref.read(selectedProductUIDProvider.notifier).state = product.uid;
    ref.read(isScheduledProvider.notifier).state = product.isScheduled;
    product.isScheduled
        ? StandardItems(ref: ref).set(product)
        : StandardIngredients(ref: ref).set(product);
  }

  setFavoritesProviders(
      WidgetRef ref, ProductModel product, FavoritesModel favorite) {
    ref.read(selectedProductIdProvider.notifier).state = product.productId;
    ref.read(isScheduledProvider.notifier).state = product.isScheduled;
    ref.read(selectedProductUIDProvider.notifier).state = product.uid;
    product.isScheduled
        ? StandardItems(ref: ref).set(product)
        : StandardIngredients(ref: ref).set(product);
    ref
        .read(selectedIngredientsProvider.notifier)
        .addIngredients(favorite.ingredients);
    ref
        .read(selectedToppingsProvider.notifier)
        .addMultipleToppings(favorite.toppings);
    ref.read(itemKeyProvider.notifier).state = Formulas.idGenerator();
    ref.read(itemSizeProvider.notifier).state = favorite.size;
    ref
        .read(selectedAllergiesProvider.notifier)
        .addListOfAllergies(favorite.allergies);
  }

  String matchedItemKey(
      List<Map<String, dynamic>> listOfItems, Map<String, dynamic> item) {
    var matchedItems = listOfItems.where((element) {
      final selectedIngredientsEqual = const DeepCollectionEquality.unordered()
          .equals(element['selectedIngredients'], item['selectedIngredients']);
      final selectedToppingsEqual = const DeepCollectionEquality.unordered()
          .equals(element['selectedToppings'], item['selectedToppings']);
      final selectedAllergiesEqual = const DeepCollectionEquality.unordered()
          .equals(element['allergies'], item['allergies']);

      return element['productId'] == item['productId'] &&
          element['itemSize'] == item['itemSize'] &&
          element['scheduledQuantity'] == item['scheduledQuantity'] &&
          (item['selectedIngredients'].isEmpty || selectedIngredientsEqual) &&
          (item['selectedToppings'].isEmpty || selectedToppingsEqual) &&
          selectedAllergiesEqual;
    }).toList();

    if (matchedItems.isEmpty) {
      return '';
    } else {
      return listOfItems.firstWhere((element) =>
          element['itemKey'] == matchedItems.first['itemKey'])['itemKey'];
    }
  }

  currentItem(WidgetRef ref, ProductModel product, PointsDetailsModel points) {
    final user = ref.watch(currentUserProvider).value ?? const UserModel();
    final standardIngredients = ref.watch(standardIngredientsProvider);
    final selectedIngredients = ref.watch(selectedIngredientsProvider);
    final bool isMember = user.uid != null && user.subscriptionStatus!.isActive;
    final itemQuantity = ref.watch(itemQuantityProvider);
    final scheduledQuantity = ref.watch(scheduledQuantityProvider);
    final scheduledDescriptor = ref.watch(scheduledQuantityDescriptorProvider);
    final itemSize = ref.watch(itemSizeProvider);
    final hasToppings = ref.watch(productHasToppingsProvider);
    final selectedToppings = ref.watch(selectedToppingsProvider);
    final allergies = ref.watch(selectedAllergiesProvider);
    // Filter variations based on user type (MEMBER or CUSTOMER)
    var filteredVariations = product.variations
        .where((variation) =>
            (isMember && variation['customerType'] == 'MEMBER') ||
            (!isMember && variation['customerType'] == 'CUSTOMER'))
        .toList();

    // Select the appropriate variation based on itemSize or other criteria
    var selectedVariation =
        filteredVariations.isNotEmpty ? filteredVariations[itemSize] : null;

    return {
      'productId': product.productId,
      'productUID': product.uid,
      'isScheduled': product.isScheduled,
      'isModifiable': product.isModifiable,
      'itemQuantity': itemQuantity,
      'scheduledQuantity': scheduledQuantity,
      'scheduledDescriptor': scheduledDescriptor,
      'itemSize': itemSize,
      'itemSizeName': selectedVariation?['name'],
      'squareVariationId': selectedVariation?['squareVariationId'],
      'itemKey': Formulas.idGenerator(),
      'points': PointsHelper()
          .getPointValue(product.productId, points.rewardsAmounts),
      'hasToppings': hasToppings,
      'selectedIngredients': selectedIngredients,
      'standardIngredients': standardIngredients,
      'selectedToppings': selectedToppings,
      'allergies': allergies,
      'notes': null,
    };
  }

  addToBag(
    WidgetRef ref,
    Map<String, dynamic> currentItem,
    ProductModel product,
    PointsDetailsModel points,
  ) {
    ref.read(currentOrderItemsProvider.notifier).addItem(currentItem);
  }

  updateDuplicateItemInBag(
    WidgetRef ref,
    Map<String, dynamic> currentItem,
    ProductModel product,
    PointsDetailsModel points,
    String itemKey,
  ) {
    ref
        .read(currentOrderItemsProvider.notifier)
        .updateDuplicateItem(currentItem, itemKey);
  }

  editItemInBag(
    WidgetRef ref,
    ProductModel product,
    PointsDetailsModel points,
  ) {
    ref
        .read(currentOrderItemsProvider.notifier)
        .editItem(ref, currentItem(ref, product, points));
  }

  addCost(WidgetRef ref, Map<String, dynamic> currentItem, ProductModel product,
      PointsDetailsModel points) {
    final itemQuantity = ref.watch(itemQuantityProvider);
    final scheduledQuantity = ref.watch(scheduledQuantityProvider);
    final itemSize = ref.watch(itemSizeProvider);
    final PricingHelpers pricingHelpers = PricingHelpers();
    final nonMemberVariations = product.variations
        .where(
            (element) => element['customerType'] == AppConstants.nonMemberType)
        .toList();
    final memberVariations = product.variations
        .where((element) => element['customerType'] == AppConstants.memberType)
        .toList();
    final nonMemberAmount = nonMemberVariations[itemSize]['amount'];
    final memberAmount = memberVariations[itemSize]['amount'];

    ref.read(currentOrderCostProvider.notifier).addCost({
      'itemPriceNonMember': nonMemberAmount,
      'modifierPriceNonMember':
          (pricingHelpers.totalCostForExtraChargeIngredientsForNonMembers(ref) *
              100),
      'itemPriceMember': memberAmount,
      'modifierPriceMember':
          pricingHelpers.totalCostForExtraChargeIngredientsForMembers(ref),
      'points': PointsHelper()
          .getPointValue(product.productId, points.rewardsAmounts),
      'productId': product.productId,
      'itemKey': currentItem['itemKey'],
      'itemQuantity': itemQuantity,
      'scheduledQuantity': scheduledQuantity,
    });

    ref.invalidate(itemQuantityProvider);
    ref.invalidate(selectedIngredientsProvider);
    ref.invalidate(scheduledQuantityProvider);
    ref.invalidate(itemSizeProvider);
    ref.invalidate(editOrderProvider);
    ref.invalidate(productHasToppingsProvider);
    ref.invalidate(selectedToppingsProvider);
    ref.invalidate(selectedAllergiesProvider);
    ref.invalidate(itemKeyProvider);
    ref.invalidate(selectedProductIdProvider);
  }

  String getBlendedAndToppedStandardIngredientAmount(
      List<dynamic> adjusted, IngredientModel ingredient, int index) {
    final isBlended = adjusted[index]['blended'];
    final isTopped = adjusted[index]['topping'];
    if (adjusted[index]['amount'] == 1) {
      return '';
    }
    if (isBlended == 0 && isTopped == 0) {
      return '';
    }
    if (isBlended == null || isTopped == null) {
      if (adjusted[index]['amount'] == 0.5) {
        return 'Light ${ingredient.name}';
      } else if (adjusted[index]['amount'] == 2) {
        return 'Extra ${ingredient.name}';
      } else {
        return '';
      }
    } else {
      return 'No ${isBlended == 1 ? 'Blended' : 'Topped'} ${ingredient.name}';
    }
  }

  blendedOrToppingDescription(WidgetRef ref, List<dynamic> added,
      IngredientModel ingredient, int orderIndex, int index) {
    final currentOrder = ref.watch(currentOrderItemsProvider);
    if (!currentOrder[orderIndex]['hasToppings'] ||
        ingredient.isTopping == false) {
      return '+';
    } else if (ingredient.isTopping &&
        added[index]['isExtraCharge'] != true &&
        added[index]['blended'] == 0 &&
        added[index]['topping'] == 1) {
      return '+ Blended';
    } else if (ingredient.isTopping &&
        added[index]['isExtraCharge'] != true &&
        added[index]['blended'] == 1 &&
        added[index]['topping'] == 0) {
      return '+ Topped';
    } else if (added[index]['blended'] == 1 && added[index]['topping'] == 1) {
      return '+ Blended & Topped';
    } else if (added[index]['isExtraCharge'] == true &&
        added[index]['blended'] == 0 &&
        added[index]['topping'] > 0) {
      return '+ Topped';
    } else if (added[index]['isExtraCharge'] == true &&
        added[index]['blended'] > 0 &&
        added[index]['topping'] == 0) {
      return '+ Blended';
    } else {
      return '+${added[index]['blended'] > 0 ? ' x${added[index]['blended']}' : ''} Blended & ${added[index]['topping'] > 0 ? 'x${added[index]['topping']} ' : ''}Topped';
    }
  }

  String modifiedIngredientAmount(
      List<dynamic> added, IngredientModel ingredient, int index) {
    String description = '';
    final amount = added[index]['amount'];
    final blended = added[index]['blended'];
    final topping = added[index]['topping'];
    final isExtraCharge = added[index]['isExtraCharge'];

    if (isExtraCharge == true) {
      return '';
    }

    if ((blended == 0 && topping == 0) ||
        (blended == null && topping == null)) {
      if (amount == 0.5) {
        description = ' Light';
      } else if (amount == 2) {
        description = ' Extra';
      }
    }
    return description;
  }

  int extraChargeIngredientQuantity(List<dynamic> added, int index) {
    var item = added[index];
    if (item['isExtraCharge'] != true) return 1;

    if (item['blended'] == null && item['topping'] == null) {
      return item['amount'] ?? 1;
    }

    if (item['blended'] != null && item['topping'] != null) {
      int blended = item['blended'];
      int topping = item['topping'];

      if (blended > 1 && topping < 1) return blended;
      if (blended < 1 && topping > 1) return topping;
    }

    return 1;
  }

  int calculateTotalExtraChargeQuantity(List<dynamic> added, int index) {
    var item = added[index];
    if (item['isExtraCharge'] != true) return 1;

    if (item['blended'] == null && item['topping'] == null) {
      return item['amount'] ?? 1;
    }

    int blended = item['blended'] ?? 0;
    int topping = item['topping'] ?? 0;

    // Adjusting the logic to handle blended and topping similarly to extraChargeIngredientQuantity
    if (blended > 0 || topping > 0) {
      return blended + topping;
    }

    return 1; // Default return 1 if neither blended nor topping is significant
  }

  determineModifierPriceText(UserModel user, List<dynamic> added, int index) {
    final isExtraCharge = added[index]['isExtraCharge'] == true;
    num totalAmount = 0.0;
    final pricePerUnit = num.tryParse(added[index]['price'])!;
    final quantity = added[index]['amount'];
    final blended = added[index]['blended'] ?? 0;
    final topping = added[index]['topping'] ?? 0;

    if (blended == 0 && topping == 0) {
      totalAmount = pricePerUnit * quantity;
    } else {
      totalAmount = pricePerUnit * (blended + topping);
    }
    final price = totalAmount / 100; //Total amount is in cents
    final isActiveMember =
        user.uid != null && user.subscriptionStatus!.isActive;
    return isExtraCharge
        ? isActiveMember
            ? '-\u00A0Free'
            : '+\u2060\$${price.toStringAsFixed(2)}'
        : '';
  }

  List<dynamic> removedItems(WidgetRef ref, int orderIndex) {
    final currentOrder = ref.watch(currentOrderItemsProvider);
    final selectedIngredients = currentOrder[orderIndex]['selectedIngredients'];
    final standardIngredients = currentOrder[orderIndex]['standardIngredients'];

    if (selectedIngredients.isEmpty) {
      return [];
    }
    final standardIngredientsID =
        standardIngredients.map((ingredient) => ingredient['id']).toSet();
    final selectedIngredientsID =
        selectedIngredients.map((ingredient) => ingredient['id']).toSet();

    final removedIngredientsID =
        standardIngredientsID.difference(selectedIngredientsID);

    return removedIngredientsID.toList();
  }

  modifiedStandardItems(WidgetRef ref, int orderIndex) {
    final currentOrder = ref.watch(currentOrderItemsProvider);

    final selectedIngredients = currentOrder[orderIndex]['selectedIngredients'];
    final standardIngredientsID = currentOrder[orderIndex]
            ['standardIngredients']
        .map((selected) => selected['id'])
        .toSet();

    return selectedIngredients
        .where((element) =>
            standardIngredientsID.contains(element['id']) == true &&
            element['amount'] != 1 &&
            element['isExtraCharge'] != true)
        .toList();
  }

  addedItems(WidgetRef ref, int orderIndex) {
    final currentOrder = ref.watch(currentOrderItemsProvider);
    final selectedIngredients = currentOrder[orderIndex]['selectedIngredients'];
    final standardIngredientsID = currentOrder[orderIndex]
            ['standardIngredients']
        .map((selected) => selected['id'])
        .toSet();

    return selectedIngredients
        .where(
            (ingredient) => !standardIngredientsID.contains(ingredient['id']))
        .toList();
  }
}
