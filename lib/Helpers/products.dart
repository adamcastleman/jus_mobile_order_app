import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/error.dart';
import 'package:jus_mobile_order_app/Helpers/formulas.dart';
import 'package:jus_mobile_order_app/Helpers/loading.dart';
import 'package:jus_mobile_order_app/Helpers/points.dart';
import 'package:jus_mobile_order_app/Helpers/pricing.dart';
import 'package:jus_mobile_order_app/Helpers/set_standard_ingredients.dart';
import 'package:jus_mobile_order_app/Helpers/set_standard_items.dart';
import 'package:jus_mobile_order_app/Models/favorites_model.dart';
import 'package:jus_mobile_order_app/Models/ingredient_model.dart';
import 'package:jus_mobile_order_app/Models/points_details_model.dart';
import 'package:jus_mobile_order_app/Models/product_model.dart';
import 'package:jus_mobile_order_app/Models/user_model.dart';
import 'package:jus_mobile_order_app/Providers/discounts_provider.dart';
import 'package:jus_mobile_order_app/Providers/product_providers.dart';
import 'package:jus_mobile_order_app/Providers/stream_providers.dart';
import 'package:jus_mobile_order_app/constants.dart';

class ProductHelpers {
  final WidgetRef ref;

  ProductHelpers({required this.ref});

  setProductProviders(ProductModel product) {
    ref.read(selectedProductIDProvider.notifier).state = product.productID;
    ref.read(selectedProductUIDProvider.notifier).state = product.uid;
    ref.read(isScheduledProvider.notifier).state = product.isScheduled;
    product.isScheduled
        ? StandardItems(ref: ref).set(product)
        : StandardIngredients(ref: ref).set(product);
    ref.read(itemKeyProvider.notifier).state = Formulas().idGenerator();
  }

  setFavoritesProviders(ProductModel product, FavoritesModel favorite) {
    ref.read(selectedProductIDProvider.notifier).state = product.productID;
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
    ref.read(itemKeyProvider.notifier).state = Formulas().idGenerator();
    ref.read(itemSizeProvider.notifier).state = favorite.size;
    ref
        .read(selectedAllergiesProvider.notifier)
        .addListOfAllergies(favorite.allergies);
  }

  currentItem(ProductModel product, PointsDetailsModel points) {
    final standardIngredients = ref.watch(standardIngredientsProvider);
    final selectedIngredients = ref.watch(selectedIngredientsProvider);
    final itemQuantity = ref.watch(itemQuantityProvider);
    final scheduledQuantity = ref.watch(scheduledQuantityProvider);
    final scheduledDescriptor = ref.watch(scheduledQuantityDescriptorProvider);
    final itemSize = ref.watch(itemSizeProvider);
    final hasToppings = ref.watch(productHasToppingsProvider);
    final selectedToppings = ref.watch(selectedToppingsProvider);
    final allergies = ref.watch(selectedAllergiesProvider);
    return {
      'productID': product.productID,
      'productUID': product.uid,
      'isScheduled': product.isScheduled,
      'isModifiable': product.isModifiable,
      'itemQuantity': itemQuantity,
      'scheduledQuantity': scheduledQuantity,
      'scheduledDescriptor': scheduledDescriptor,
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

  addToBag(
    ProductModel product,
    PointsDetailsModel points,
  ) {
    ref
        .read(currentOrderItemsProvider.notifier)
        .addItem(currentItem(product, points));
  }

  editItemInBag(
    ProductModel product,
    PointsDetailsModel points,
  ) {
    ref
        .read(currentOrderItemsProvider.notifier)
        .editItem(ref, currentItem(product, points));
  }

  addCost(ProductModel product, PointsDetailsModel points) {
    final itemQuantity = ref.watch(itemQuantityProvider);
    final scheduledQuantity = ref.watch(scheduledQuantityProvider);
    final itemSize = ref.watch(itemSizeProvider);
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
          (Pricing(ref: ref).totalCostForExtraChargeIngredientsForNonMembers() *
              100),
      'itemPriceMember': memberAmount,
      'modifierPriceMember':
          Pricing(ref: ref).totalCostForExtraChargeIngredientsForMembers(),
      'points': PointsHelper(ref: ref)
          .getPointValue(product.productID, points.rewardsAmounts),
      'productID': product.productID,
      'itemKey': ref.watch(itemKeyProvider),
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
    ref.invalidate(selectedProductIDProvider);
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

  blendedOrToppingDescription(List<dynamic> added, IngredientModel ingredient,
      int orderIndex, int index) {
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

  String extraChargeIngredientQuantity(List<dynamic> added, int index) {
    var item = added[index];
    if (item['isExtraCharge'] != true) return '';
    if (item['blended'] == null && item['topping'] == null) {
      return ' x${item['amount']}';
    }
    if (item['blended'] != null && item['topping'] != null) {
      int blended = item['blended'];
      int topping = item['topping'];
      if (blended > 1 && topping < 1) return ' x$blended';
      if (blended < 1 && topping > 1) return ' x$topping';
      return '';
    }
    return '';
  }

  determineModifierPriceText(UserModel user, List<dynamic> added, int index) {
    final isExtraCharge = added[index]['isExtraCharge'] == true;
    final price = num.tryParse(added[index]['price'])! / 100;
    final isActiveMember = user.uid != null && user.isActiveMember!;
    return isExtraCharge
        ? isActiveMember
            ? '-\u00A0Free'
            : '+\u2060\$${price.toStringAsFixed(2)}'
        : '';
  }

  List<dynamic> removedItems(int orderIndex) {
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

  modifiedStandardItems(int orderIndex) {
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

  addedItems(int orderIndex) {
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

  generateProductList() {
    final currentUser = ref.watch(currentUserProvider).value!;
    final currentOrder = ref.watch(currentOrderItemsProvider);
    final currentOrderCosts = ref.watch(currentOrderCostProvider);
    final listOfDiscounts = ref.watch(discountTotalProvider);
    final products = ref.watch(productsProvider);
    final ingredients = ref.watch(ingredientsProvider);

    return ingredients.when(
      error: (e, _) => ShowError(error: e.toString()),
      loading: () => const Loading(),
      data: (ingredients) => products.when(
        error: (e, _) => ShowError(error: e.toString()),
        loading: () => const Loading(),
        data: (product) {
          return _buildFinalList(currentUser, currentOrder, currentOrderCosts,
              listOfDiscounts, product, ingredients);
        },
      ),
    );
  }

  List _buildFinalList(
      UserModel user,
      List currentOrder,
      List currentOrderCosts,
      List listOfDiscounts,
      List<ProductModel> product,
      List<IngredientModel> ingredients) {
    List finalList = [];

    for (var index = 0; index < currentOrder.length; index++) {
      final productId = currentOrder[index]['productID'];
      final currentProduct =
          product.firstWhere((element) => element.productID == productId);
      final itemMap = _buildItemMap(user, currentOrder, currentOrderCosts,
          listOfDiscounts, index, currentProduct, product, ingredients);
      finalList.add(itemMap);
    }

    return finalList;
  }

  Map _buildItemMap(
    UserModel user,
    List currentOrder,
    List currentOrderCosts,
    List listOfDiscounts,
    int index,
    ProductModel currentProduct,
    List<ProductModel> product,
    List<IngredientModel> ingredients,
  ) {
    int itemDiscount = 0;
    double itemDiscountNonMember = 0.00;
    double itemDiscountMember = 0.00;
    int productID = currentProduct.productID;
    String productName = currentProduct.name;
    String category = currentProduct.category;
    String image = currentProduct.image;
    String itemKey = currentOrder[index]['itemKey'];
    int itemQuantity = currentOrder[index]['itemQuantity'];
    bool isScheduled = currentProduct.isScheduled;
    int? scheduledQuantity = currentProduct.isScheduled
        ? currentOrder[index]['scheduledQuantity']
        : null;
    String? scheduledDescriptor = currentProduct.isScheduled
        ? currentOrder[index]['scheduledDescriptor']
        : null;
    final nonMemberVariations = currentProduct.variations
        .where(
            (element) => element['customerType'] == AppConstants.nonMemberType)
        .toList();
    String? itemSize =
        !currentProduct.isScheduled && currentProduct.isModifiable
            ? nonMemberVariations[currentOrder[index]['itemSize']]['name']
            : null;

    int itemPriceNonMember = currentOrderCosts
        .firstWhere(
            (element) => element['itemKey'] == itemKey)['itemPriceNonMember']
        .toInt();
    int itemPriceMember = currentOrderCosts
        .firstWhere(
            (element) => element['itemKey'] == itemKey)['itemPriceMember']
        .toInt();
    int modifierPriceNonMember = currentOrderCosts
        .firstWhere((element) => element['itemKey'] == itemKey)[
            'modifierPriceNonMember']
        .toInt();
    int modifierPriceMember = currentOrderCosts
        .firstWhere(
            (element) => element['itemKey'] == itemKey)['modifierPriceMember']
        .toInt();

    if (listOfDiscounts.isNotEmpty) {
      var discountElement = listOfDiscounts.firstWhere(
          (element) => element['itemKey'] == itemKey,
          orElse: () => null);

      if (discountElement != null) {
        itemDiscountNonMember = discountElement['itemPriceNonMember'] ?? 0;
        itemDiscountMember = discountElement['itemPriceMember'] ?? 0;
      }
    }

    itemDiscount = (user.uid == null || user.isActiveMember == false)
        ? itemDiscountNonMember.toInt()
        : itemDiscountMember.toInt();
    List selectedToppingsList =
        _buildSelectedToppingsList(currentOrder[index], ingredients);
    List addedList =
        _buildAddedList(currentOrder[index], ingredients, user, index);
    List adjustedList =
        _buildAdjustedList(currentOrder[index], ingredients, index);
    List removedList =
        _buildRemovedList(currentOrder[index], ingredients, index);
    List allergiesList = _buildAllergiesList(currentOrder[index], ingredients);

    List ingredientModificationList = [
      ...selectedToppingsList,
      ...removedList,
      ...adjustedList,
      ...addedList
    ];

    return {
      'name': productName,
      'image': image,
      'category': category,
      'id': productID,
      'itemDiscount': itemDiscount,
      'itemQuantity': itemQuantity,
      'size': itemSize,
      'isScheduled': isScheduled,
      'scheduledQuantity': scheduledQuantity,
      'scheduledDescriptor': scheduledDescriptor,
      'modifications': ingredientModificationList,
      'allergies': allergiesList,
      'price': user.uid == null || user.isActiveMember == false
          ? itemPriceNonMember
          : itemPriceMember,
      'modifierPrice': user.uid == null || user.isActiveMember == false
          ? modifierPriceNonMember
          : modifierPriceMember,
    };
  }

  List<String> _buildSelectedToppingsList(
      Map order, List<IngredientModel> ingredients) {
    List<String> selectedToppingsList = [];
    List selectedToppings = order['selectedToppings'];

    for (var id in selectedToppings) {
      final ingredient = ingredients.firstWhere((element) => element.id == id);
      selectedToppingsList.add('{"name": "+${ingredient.name}", "price": "0"}');
    }

    return selectedToppingsList;
  }

  List<String> _buildAddedList(
      Map order, List<IngredientModel> ingredients, UserModel user, int index) {
    List<String> addedList = [];
    List added = addedItems(index);

    for (var addedIngredient in added) {
      final ingredient = ingredients
          .firstWhere((element) => element.id == addedIngredient['id']);
      final selectedIngredient = order['selectedIngredients']
          .firstWhere((element) => element['id'] == ingredient.id);

      int premiumIngredientPrice = double.parse(
              user.isActiveMember == null || user.isActiveMember == false
                  ? (selectedIngredient['price'])
                  : (selectedIngredient['memberPrice']))
          .toInt();
      String blendedOrTopping = blendedOrToppingDescription(
          added, ingredient, index, added.indexOf(addedIngredient));
      var amount = modifiedIngredientAmount(
          added, ingredient, added.indexOf(addedIngredient));
      var extraChargeIngredientAmount =
          extraChargeIngredientQuantity(added, added.indexOf(addedIngredient));

      addedList.add(
          '{"name": "$blendedOrTopping ${ingredient.name}$amount$extraChargeIngredientAmount", "price": "$premiumIngredientPrice"}');
    }

    return addedList;
  }

  List<String> _buildAdjustedList(
      Map order, List<IngredientModel> ingredients, int index) {
    List<String> adjustedList = [];
    List adjusted = ProductHelpers(ref: ref).modifiedStandardItems(index);

    for (var adjustedIngredient in adjusted) {
      final ingredient = ingredients
          .firstWhere((element) => element.id == adjustedIngredient['id']);
      String adjustedDescriptor = getBlendedAndToppedStandardIngredientAmount(
          adjusted, ingredient, adjusted.indexOf(adjustedIngredient));
      adjustedList.add('{"name": "$adjustedDescriptor", "price": "0"}');
    }

    return adjustedList;
  }

  List<String> _buildRemovedList(
      Map order, List<IngredientModel> ingredients, int index) {
    List<String> removedList = [];
    List removed = ProductHelpers(ref: ref).removedItems(index);

    for (var removedIngredient in removed) {
      final ingredient =
          ingredients.firstWhere((element) => element.id == removedIngredient);

      removedList.add('{"name": "No ${ingredient.name}",  "price": "0"}');
    }

    return removedList;
  }

  List<String> _buildAllergiesList(
      Map order, List<IngredientModel> ingredients) {
    List<String> allergiesList = [];
    List allergies = order['allergies'];

    for (var allergy in allergies) {
      final ingredient =
          ingredients.firstWhere((element) => element.id == allergy);
      allergiesList.add(ingredient.name);
    }

    return allergiesList;
  }
}
