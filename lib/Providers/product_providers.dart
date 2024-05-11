import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/enums.dart';
import 'package:jus_mobile_order_app/Models/favorites_model.dart';
import 'package:jus_mobile_order_app/Models/ingredient_model.dart';
import 'package:jus_mobile_order_app/Models/product_model.dart';
import 'package:jus_mobile_order_app/Models/user_model.dart';
import 'package:jus_mobile_order_app/Providers/controller_providers.dart';
import 'package:jus_mobile_order_app/Widgets/Cards/animated_list_card.dart';

final allProductsProvider = StateProvider<List<ProductModel>>((ref) => []);

final allIngredientsProvider =
    StateProvider<List<IngredientModel>>((ref) => []);

final allFavoritesProvider = StateProvider<List<FavoritesModel>>((ref) => []);

final tappedCategoryProvider = StateProvider.autoDispose<int>((ref) => 0);

final scrollSourceProvider = StateProvider<String>((ref) => 'scroll');

final currentCategoryProvider = StateProvider.autoDispose<int>((ref) => 1);

final categoryHeaderHeightProvider = Provider<double>((ref) => 50);

final selectedProductProvider = StateProvider<ProductModel?>((ref) => null);

final productGridCrossAxisCountMobileProvider = Provider<int>((ref) => 2);

final productGridCrossAxisCountTabletProvider = Provider<int>((ref) => 3);

final productGridCrossAxisCountWebProvider = Provider<int>((ref) => 4);

final productGridCrossAxisSpacingProvider = Provider<double>((ref) => 6);

final productGridMainAxisSpacingProvider = Provider<double>((ref) => 6);

final categoryItemWidthProvider = Provider<double>((ref) => 80.0);

final productGridMobileAspectRatioProvider = Provider<double>((ref) => 1 / 1.5);

final productGridTabletAspectRatioProvider =
    Provider<double>((ref) => 1 / 1.25);

final productGridWebAspectRatioProvider = Provider<double>((ref) => 1);

final groupedScrollControllerProvider = Provider<ScrollController>((ref) {
  return ScrollController();
});

final isModifiableProductProvider = StateProvider<bool>((ref) => false);

final productHasToppingsProvider = StateProvider<bool>((ref) => false);

final selectedProductIdProvider = StateProvider<String?>((ref) => null);

final selectedProductUIDProvider = StateProvider<String?>((ref) => null);

final itemSizeProvider = StateProvider<int>((ref) => 0);

final editOrderProvider = StateProvider<bool>((ref) => false);

final itemKeyProvider = StateProvider<String>((ref) => '');

final isFavoritesSheetProvider =
    StateProvider.autoDispose<bool>((ref) => false);

final itemQuantityProvider = StateNotifierProvider<SelectItemQuantity, int>(
    (ref) => SelectItemQuantity());

final scheduledQuantityDescriptorProvider =
    StateProvider<String?>((ref) => null);

final scheduledQuantityProvider =
    StateNotifierProvider<SelectScheduledQuantity, int>(
        (ref) => SelectScheduledQuantity());

final animatedListKeyProvider =
    Provider.autoDispose<GlobalKey<AnimatedListState>>(
        (ref) => GlobalKey<AnimatedListState>());

final currentIngredientIdProvider = StateProvider<int?>((ref) => null);

final currentIngredientIndexProvider = StateProvider<int?>((ref) => null);

final isScheduledProvider = StateProvider<bool>((ref) => false);

final favoriteItemNameProvider = StateProvider<String>((ref) => '');

final currentIngredientExtraChargeProvider =
    StateProvider<bool>((ref) => false);

final currentIngredientBlendedProvider = StateProvider<bool>((ref) => true);

final currentIngredientToppingProvider = StateProvider<bool>((ref) => true);

final extraChargeBlendedIngredientQuantityProvider =
    StateNotifierProvider<SelectExtraChargeIngredientQuantity, int>(
  (ref) => SelectExtraChargeIngredientQuantity(),
);

final extraChargeToppedIngredientQuantityProvider =
    StateNotifierProvider<SelectExtraChargeIngredientQuantity, int>(
  (ref) => SelectExtraChargeIngredientQuantity(),
);

final standardIngredientsProvider =
    StateProvider<List<Map<String, dynamic>>>((ref) => [{}]);

final selectedIngredientsProvider =
    StateNotifierProvider<ListOfIngredients, List<dynamic>>(
        (ref) => ListOfIngredients());

final standardItemsProvider =
    StateProvider<List<Map<String, dynamic>>>((ref) => [{}]);

final selectedAllergiesProvider =
    StateNotifierProvider<SelectedAllergies, List<int>>(
        (ref) => SelectedAllergies());

final selectedToppingsProvider =
    StateNotifierProvider<SelectedToppings, List<int>>(
        (ref) => SelectedToppings());

final currentOrderItemsProvider =
    StateNotifierProvider<CurrentOrderItems, List<Map<String, dynamic>>>(
        (ref) => CurrentOrderItems());

final currentOrderCostProvider =
    StateNotifierProvider<CurrentOrderCost, List<Map<String, dynamic>>>(
        (ref) => CurrentOrderCost());

final currentOrderItemsIndexProvider = StateProvider<int>((ref) => 0);

class SelectedToppings extends StateNotifier<List<int>> {
  SelectedToppings() : super([]);

  add(int ingredient, int quantityLimit) {
    if (state.length == quantityLimit) {
      state = state;
    } else {
      HapticFeedback.lightImpact();
      state = [...state, ingredient];
    }
  }

  addMultipleToppings(List<dynamic> ingredients) {
    state = [...state, ...ingredients];
  }

  remove(int ingredient) {
    HapticFeedback.lightImpact();
    List<int> newList = [...state];
    newList.removeWhere((element) => element == ingredient);
    state = newList;
  }
}

class SelectedAllergies extends StateNotifier<List<int>> {
  SelectedAllergies() : super([]);

  add(int ingredient) {
    HapticFeedback.lightImpact();
    state = [...state, ingredient];
  }

  addListOfAllergies(List<dynamic> ingredients) {
    state = [...state, ...ingredients];
  }

  remove(int ingredient) {
    HapticFeedback.lightImpact();
    List<int> newList = [...state];
    newList.removeWhere((element) => element == ingredient);
    state = newList;
  }
}

class SelectItemQuantity extends StateNotifier<int> {
  SelectItemQuantity() : super(1);

  increment(int? quantityLimit) {
    if (quantityLimit == null) {
      HapticFeedback.lightImpact();
      state = state + 1;
    } else if (state == quantityLimit) {
      state = state;
    } else {
      HapticFeedback.lightImpact();
      state = state + 1;
    }
  }

  decrement() {
    if (state < 2) {
      return state = 1;
    } else {
      HapticFeedback.lightImpact();
      return state = state - 1;
    }
  }

  set(int amount) {
    state = amount;
  }
}

class SelectScheduledQuantity extends StateNotifier<int> {
  SelectScheduledQuantity() : super(1);

  increment(int? scheduledQuantity) {
    if (scheduledQuantity == null) {
      state = state + 1;
    }
    if (state == scheduledQuantity) {
      state = state;
    } else {
      HapticFeedback.lightImpact();
      state = state + 1;
    }
  }

  decrement() {
    if (state < 2) {
      return state = 1;
    } else {
      HapticFeedback.lightImpact();
      return state = state - 1;
    }
  }

  set(int amount) {
    state = amount;
  }
}

class SelectExtraChargeIngredientQuantity extends StateNotifier<int> {
  SelectExtraChargeIngredientQuantity() : super(0);

  addBlended(int blended) {
    HapticFeedback.lightImpact();
    state = blended;
  }

  addTopping(int topping) {
    HapticFeedback.lightImpact();
    state = topping;
  }

  increment() {
    if (state < 3) {
      HapticFeedback.lightImpact();
      return state = state + 1;
    }

    return state = 3;
  }

  decrement() {
    if (state > 1) {
      HapticFeedback.lightImpact();
      return state = state - 1;
    }

    return state = 0;
  }
}

class ListOfIngredients extends StateNotifier<List<dynamic>> {
  ListOfIngredients() : super([]);

  addIngredients(List<dynamic> ingredients) {
    List newList = [...ingredients];
    newList.sort((a, b) => a['id'].compareTo(b['id']));

    state = newList;
  }

  addIngredient(
      {required IngredientModel ingredient,
      required bool isExtraCharge,
      required WidgetRef ref,
      required UserModel user,
      int? blended,
      int? topping}) {
    final animatedListKey = ref.watch(animatedListKeyProvider);
    HapticFeedback.lightImpact();
    var isUserActiveMember =
        user.subscriptionStatus == SubscriptionStatus.active;
    var newList = [
      ...state,
      {
        'id': ingredient.id,
        'amount': 1,
        'isExtraCharge': isExtraCharge,
        'price': (ingredient.price).toStringAsFixed(2),
        'memberPrice': (ingredient.memberPrice).toStringAsFixed(2),
        'squareVariationId': ingredient.variations!.isEmpty
            ? null
            : isUserActiveMember
                ? ingredient.variations![1]['squareVariationId']
                : ingredient.variations![0]['squareVariationId'],
        'blended': blended ?? 0,
        'topping': topping ?? 0,
      }
    ];
    newList.sort((a, b) => a['id'].compareTo(b['id']));
    int newItemIndex =
        newList.indexWhere((element) => element['id'] == ingredient.id);

    double cardWidth = 100.0;
    if (animatedListKey.currentState != null) {
      animatedListKey.currentState!.insertItem(
        newItemIndex,
        duration: const Duration(milliseconds: 500),
      );

      double cardWidth = 100.0;
      if (animatedListKey.currentState != null) {
        ref.read(modifyIngredientsListScrollControllerProvider).animateTo(
            newItemIndex.toDouble() * cardWidth,
            duration: const Duration(milliseconds: 500),
            curve: Curves.linear);
      }
    }
    if (animatedListKey.currentState != null) {
      ref.read(modifyIngredientsListScrollControllerProvider).animateTo(
          newItemIndex.toDouble() * cardWidth,
          duration: const Duration(milliseconds: 500),
          curve: Curves.linear);
    }

    state = newList;
  }

  removeIngredient(
      int ingredient, WidgetRef ref, List<dynamic> selectedIngredients) {
    HapticFeedback.lightImpact();
    final animatedListKey = ref.watch(animatedListKeyProvider);

    if (animatedListKey.currentState != null) {
      animatedListKey.currentState!.removeItem(
        selectedIngredients
            .indexWhere((element) => element['id'] == ingredient),
        (context, animation) => SizeTransition(
          axis: Axis.horizontal,
          axisAlignment: 1,
          sizeFactor: animation,
          child: const AnimatedListCard(),
        ),
      );
    }
    List newList = [...state];
    newList.removeWhere((element) => element['id'] == ingredient);
    newList.sort((a, b) => a['id'].compareTo(b['id']));
    state = newList.toList();
  }

  replaceIngredients(WidgetRef ref) {
    HapticFeedback.lightImpact();
    final selectedIngredients = ref.watch(selectedIngredientsProvider);
    final standardIngredients = ref.watch(standardIngredientsProvider);
    final animatedListKey = ref.watch(animatedListKeyProvider);
    if (selectedIngredients.length < standardIngredients.length) {
      int totalItemsAdded =
          standardIngredients.length - selectedIngredients.length;

      if (animatedListKey.currentState != null) {
        for (var i = 0; i < totalItemsAdded; i++) {
          animatedListKey.currentState!.insertItem(
            0,
            duration: const Duration(milliseconds: 500),
          );
        }
      }
    } else {
      int totalItemsRemoved =
          selectedIngredients.length - standardIngredients.length;
      if (animatedListKey.currentState != null) {
        for (var i = 0; i < totalItemsRemoved; i++) {
          animatedListKey.currentState!.removeItem(
            0,
            (context, animation) => SizeTransition(
              axis: Axis.horizontal,
              axisAlignment: 0.5,
              sizeFactor: animation,
              child: const AnimatedListCard(),
            ),
          );
        }
      }
    }
    List newList = state;
    for (var element in newList) {
      element['amount'] = 1;
      element['blended'] = 0;
      element['topped'] = 0;
    }
    newList.replaceRange(0, state.length, standardIngredients);

    state = newList.toList();
  }

  addQuantityAmount({
    required int index,
    required bool isExtraCharge,
    required WidgetRef ref,
    required List<IngredientModel> ingredients,
    required UserModel user,
    int? blended,
    int? topping,
  }) {
    final selectedIngredients = ref.watch(selectedIngredientsProvider);
    IngredientModel currentIngredient = ingredients
        .where((element) => element.id == selectedIngredients[index]['id'])
        .first;
    List newList = [...state];
    bool isExtraCharge = currentIngredient.isExtraCharge;
    int memberPrice = currentIngredient.memberPrice;
    int price = currentIngredient.price;
    newList.removeWhere((element) => element['id'] == newList[index]['id']);

    dynamic newElement = {
      'id': selectedIngredients[index]['id'],
      'amount': 2,
      'price': (price * 2).toStringAsFixed(2),
      'isExtraCharge': isExtraCharge,
      'memberPrice': (memberPrice * 2).toStringAsFixed(2),
      'blended': blended,
      'topping': topping,
      'squareVariationId': selectedIngredients[index]['squareVariationId']
    };

    calculateExtraChargeAmount() {
      if (blended != null && topping != null) {
        HapticFeedback.lightImpact();
        return blended + topping;
      } else if (selectedIngredients[index]['amount'] < 1) {
        HapticFeedback.lightImpact();
        return 1;
      } else if (selectedIngredients[index]['amount'] == 1) {
        HapticFeedback.lightImpact();
        return 2;
      } else if (selectedIngredients[index]['amount'] == 7) {
        return selectedIngredients[index]['amount'];
      } else {
        HapticFeedback.lightImpact();
        return selectedIngredients[index]['amount'] + 1;
      }
    }

    calculateNonChargedAmount() {
      if (selectedIngredients[index]['amount'] < 1) {
        HapticFeedback.lightImpact();
        return 1;
      } else if (selectedIngredients[index]['amount'] == 1) {
        HapticFeedback.lightImpact();
        return 2;
      } else {
        return selectedIngredients[index]['amount'];
      }
    }

    if (isExtraCharge) {
      newElement = {
        'id': selectedIngredients[index]['id'],
        'isExtraCharge': isExtraCharge,
        'amount': calculateExtraChargeAmount(),
        'price': price.toStringAsFixed(2),
        'memberPrice': memberPrice.toStringAsFixed(2),
        'blended': blended,
        'topping': topping,
        'squareVariationId': selectedIngredients[index]['squareVariationId']
      };
    } else {
      newElement = {
        'id': selectedIngredients[index]['id'],
        'isExtraCharge': isExtraCharge,
        'amount': calculateNonChargedAmount(),
        'price': 0.toStringAsFixed(2),
        'memberPrice': 0.toStringAsFixed(2),
        'blended': blended,
        'topping': topping,
        'squareVariationId': selectedIngredients[index]['squareVariationId']
      };
    }
    newList.add(newElement);
    newList.sort((a, b) => a['id'].compareTo(b['id']));
    state = newList.toList();
  }

  removeQuantityAmount(int index, WidgetRef ref,
      List<IngredientModel> ingredients, UserModel user) {
    final selectedIngredients = ref.watch(selectedIngredientsProvider);
    IngredientModel currentIngredient = ingredients
        .where((element) => element.id == selectedIngredients[index]['id'])
        .first;
    List newList = [...state];
    bool isExtraCharge = currentIngredient.isExtraCharge;
    int memberPrice = currentIngredient.memberPrice;
    int price = currentIngredient.price;
    calculateChargedAmount() {
      if (selectedIngredients[index]['amount'] == 1) {
        return 1;
      }
      if (selectedIngredients[index]['amount'] <= 2) {
        HapticFeedback.lightImpact();
        return 1;
      } else {
        HapticFeedback.lightImpact();
        return selectedIngredients[index]['amount'] - 1;
      }
    }

    calculateNonChargedAmount() {
      if (selectedIngredients[index]['amount'] == 0.5) {
        return 0.5;
      } else if (selectedIngredients[index]['amount'] <= 1) {
        HapticFeedback.lightImpact();
        return 0.5;
      } else {
        HapticFeedback.lightImpact();
        return selectedIngredients[index]['amount'] - 1;
      }
    }

    newList.removeWhere((element) => element['id'] == newList[index]['id']);
    dynamic newElement = {
      'id': selectedIngredients[index]['id'],
      'amount': 2,
      'price': (price * 2).toStringAsFixed(2),
      'memberPrice': (memberPrice * 2).toStringAsFixed(2),
      'squareVariationId': selectedIngredients[index]['squareVariationId']
    };
    if (isExtraCharge) {
      newElement = {
        'id': selectedIngredients[index]['id'],
        'amount': calculateChargedAmount(),
        'price': price.toStringAsFixed(2),
        'memberPrice': memberPrice.toStringAsFixed(2),
        'squareVariationId': selectedIngredients[index]['squareVariationId']
      };
    } else {
      newElement = {
        'id': selectedIngredients[index]['id'],
        'amount': calculateNonChargedAmount(),
        'price': 0.toStringAsFixed(2),
        'memberPrice': 0.toStringAsFixed(2),
        'squareVariationId': selectedIngredients[index]['squareVariationId']
      };
    }

    newList.add(newElement);
    newList.sort((a, b) => a['id'].compareTo(b['id']));
    state = newList.toList();
  }
}

class CurrentOrderItems extends StateNotifier<List<Map<String, dynamic>>> {
  CurrentOrderItems() : super([]);

  addItem(Map<String, dynamic> item) {
    HapticFeedback.mediumImpact();
    var product = state.where((element) {
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
    });

    if (state.isEmpty || product.isEmpty) {
      state = [...state, item];
    } else {
      product.first['itemQuantity'] =
          product.first['itemQuantity'] + item['itemQuantity'];
      product.first['scheduledQuantity'] =
          product.first['isScheduled'] ? item['scheduledQuantity'] : 1;
      product.first['scheduledDescriptor'] = item['scheduledDescriptor'];
      product.first['itemSize'] = item['itemSize'];
      product.first['itemSizeName'] = item['itemSizeName'];
      product.first['squareVariationId'] = item['squareVariationId'];
      state = [...state];
    }
  }

  editItem(WidgetRef ref, Map<String, dynamic> item) {
    HapticFeedback.lightImpact();
    final currentOrder = ref.watch(currentOrderItemsProvider);
    final currentOrderIndex = ref.watch(currentOrderItemsIndexProvider);
    currentOrder[currentOrderIndex]['itemQuantity'] = item['itemQuantity'];
    currentOrder[currentOrderIndex]['scheduledQuantity'] =
        currentOrder[currentOrderIndex]['isScheduled']
            ? item['scheduledQuantity']
            : 1;
    currentOrder[currentOrderIndex]['scheduledDescriptor'] =
        item['scheduledDescriptor'];
    currentOrder[currentOrderIndex]['itemSize'] = item['itemSize'];
    currentOrder[currentOrderIndex]['itemSizeName'] = item['itemSizeName'];
    currentOrder[currentOrderIndex]['squareVariationId'] =
        item['squareVariationId'];
    currentOrder[currentOrderIndex]['itemKey'] = item['itemKey'];
    currentOrder[currentOrderIndex]['selectedIngredients'] =
        item['selectedIngredients'];
    currentOrder[currentOrderIndex]['standardIngredients'] =
        item['standardIngredients'];
    currentOrder[currentOrderIndex]['selectedToppings'] =
        item['selectedToppings'];
    currentOrder[currentOrderIndex]['allergies'] = item['allergies'];
    state = [...state];
  }

  removeItem(WidgetRef ref) {
    final currentOrderIndex = ref.watch(currentOrderItemsIndexProvider);
    HapticFeedback.lightImpact();
    List<Map<String, dynamic>> newList = [...state];
    newList.removeAt(currentOrderIndex);
    state = newList;
  }

  addItemQuantity(ProductModel currentProduct, int index) {
    HapticFeedback.lightImpact();
    List<Map<String, dynamic>> newList = [...state];
    Map<String, dynamic> item = newList[index];

    item['itemQuantity'] += 1;
    item['isScheduled'] = currentProduct.isScheduled;
    item['isModifiable'] = currentProduct.isModifiable;
    item['hasToppings'] = currentProduct.hasToppings;
    newList[index] = item;
    state = newList;
  }

  removeItemQuantity(ProductModel currentProduct, int index) {
    List<Map<String, dynamic>> newList = [...state];
    Map<String, dynamic> item = newList[index];
    if (item['itemQuantity'] > 1) {
      item['itemQuantity'] -= 1;
      HapticFeedback.lightImpact();
    }
    item['isScheduled'] = currentProduct.isScheduled;
    item['isModifiable'] = currentProduct.isModifiable;
    item['hasToppings'] = currentProduct.hasToppings;
    newList[index] = item;
    state = newList;
  }
}

class CurrentOrderCost extends StateNotifier<List<Map<String, dynamic>>> {
  CurrentOrderCost() : super([]);

  addCost(Map<String, dynamic> item) {
    int itemQuantity = item['itemQuantity'];
    int scheduledQuantity = item['scheduledQuantity'];
    int totalMaps = itemQuantity * scheduledQuantity;
    List<Map<String, dynamic>> maps = List.generate(
        totalMaps,
        (_) => {
              'itemPriceNonMember': item['itemPriceNonMember'],
              'itemPriceMember': item['itemPriceMember'],
              'modifierPriceNonMember': item['modifierPriceNonMember'],
              'modifierPriceMember': item['modifierPriceMember'],
              'points': item['points'],
              'itemKey': item['itemKey'],
              'productId': item['productId'],
              'itemQuantity': 1,
              'scheduledQuantity': 1
            });

    state = [...state, ...maps];
  }

  removeSingleCost(String itemKey) {
    List newList = state;
    var firstItemToRemove =
        newList.firstWhere((element) => element['itemKey'] == itemKey);
    if (firstItemToRemove != null) {
      newList.remove(firstItemToRemove);
    }
    state = [...newList];
  }

  removeMultipleCost(String itemKey) {
    List newList = state;
    newList.removeWhere((element) => element['itemKey'] == itemKey);
    state = [...newList];
  }
}
