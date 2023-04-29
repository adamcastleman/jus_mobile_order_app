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
import 'package:jus_mobile_order_app/Providers/product_providers.dart';
import 'package:jus_mobile_order_app/Providers/stream_providers.dart';

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
    final scheduledQuantity = ref.watch(scheduledQuantityProvider);
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

  String extraChargeQuantity(List<dynamic> added, int index) {
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
    final currentUser = ref.watch(currentUserProvider);
    final currentOrder = ref.watch(currentOrderItemsProvider);
    final currentOrderCosts = ref.watch(currentOrderCostProvider);
    final products = ref.watch(productsProvider);
    final ingredients = ref.watch(ingredientsProvider);

    return currentUser.when(
      error: (e, _) => ShowError(error: e.toString()),
      loading: () => const Loading(),
      data: (user) => ingredients.when(
        error: (e, _) => ShowError(error: e.toString()),
        loading: () => const Loading(),
        data: (ingredients) => products.when(
          error: (e, _) => ShowError(error: e.toString()),
          loading: () => const Loading(),
          data: (product) {
            return _buildFinalList(
                user, currentOrder, currentOrderCosts, product, ingredients);
          },
        ),
      ),
    );
  }

  List _buildFinalList(
      UserModel user,
      List currentOrder,
      List currentOrderCosts,
      List<ProductModel> product,
      List<IngredientModel> ingredients) {
    List finalList = [];

    for (var index = 0; index < currentOrder.length; index++) {
      final currentProduct =
          _findProduct(currentOrder[index]['productID'], product);
      final itemMap = _buildItemMap(user, currentOrder, currentOrderCosts,
          index, currentProduct, product, ingredients);
      finalList.add(itemMap);
    }

    return finalList;
  }

  ProductModel _findProduct(int productID, List<ProductModel> product) {
    return product.firstWhere((element) => element.productID == productID);
  }

  Map _buildItemMap(
    UserModel user,
    List currentOrder,
    List currentOrderCosts,
    int index,
    ProductModel currentProduct,
    List<ProductModel> product,
    List<IngredientModel> ingredients,
  ) {
    int productID = currentProduct.productID;
    String productName = currentProduct.name;
    String image = currentProduct.image;
    int itemQuantity = currentOrder[index]['itemQuantity'];
    bool isScheduled = currentProduct.isScheduled;
    int? scheduledQuantity = currentProduct.isScheduled
        ? currentOrder[index]['scheduledQuantity']
        : null;
    String? scheduledDescriptor = currentProduct.isScheduled
        ? currentOrder[index]['scheduledDescriptor']
        : null;
    String? itemSize =
        !currentProduct.isScheduled && currentProduct.isModifiable
            ? currentProduct.price[currentOrder[index]['itemSize']]['name']
            : null;

    int itemPriceNonMember = currentOrderCosts
        .firstWhere((element) =>
            element['itemKey'] == currentOrder[index]['itemKey'])['price']
        .toInt();
    int itemPriceMember = currentOrderCosts
        .firstWhere((element) =>
            element['itemKey'] == currentOrder[index]['itemKey'])['memberPrice']
        .toInt();

    List selectedToppingsList =
        _buildSelectedToppingsList(currentOrder[index], ingredients);
    List addedList = _buildAddedList(currentOrder[index], ingredients, index);
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
      'id': productID,
      'itemQuantity': itemQuantity,
      'size': itemSize,
      'isScheduled': isScheduled,
      'scheduledQuantity': scheduledQuantity,
      'scheduledDescriptor': scheduledDescriptor,
      'modifications': ingredientModificationList,
      'allergies': allergiesList,
      'price': user.uid == null || !user.isActiveMember!
          ? itemPriceNonMember
          : itemPriceMember,
    };
  }

  List<String> _buildSelectedToppingsList(
      Map order, List<IngredientModel> ingredients) {
    List<String> selectedToppingsList = [];
    List selectedToppings = order['selectedToppings'];

    for (var id in selectedToppings) {
      final ingredient = ingredients.firstWhere((element) => element.id == id);
      selectedToppingsList.add('+${ingredient.name}');
    }

    return selectedToppingsList;
  }

  List<String> _buildAddedList(
      Map order, List<IngredientModel> ingredients, int index) {
    List<String> addedList = [];
    List added = addedItems(index);

    for (var addedIngredient in added) {
      final ingredient = ingredients
          .firstWhere((element) => element.id == addedIngredient['id']);
      String blendedOrTopping = blendedOrToppingDescription(
          added, ingredient, index, added.indexOf(addedIngredient));
      var amount = modifiedIngredientAmount(
          added, ingredient, added.indexOf(addedIngredient));
      var extraChargeAmount =
          extraChargeQuantity(added, added.indexOf(addedIngredient));
      addedList
          .add('$blendedOrTopping ${ingredient.name}$amount$extraChargeAmount');
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
      adjustedList.add(adjustedDescriptor);
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
      removedList.add('No ${ingredient.name}');
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
