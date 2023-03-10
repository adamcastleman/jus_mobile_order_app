import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Models/ingredient_model.dart';
import 'package:jus_mobile_order_app/Models/product_model.dart';
import 'package:jus_mobile_order_app/Models/user_model.dart';
import 'package:jus_mobile_order_app/Widgets/Cards/animated_list_card.dart';

final categoryOrderProvider = StateProvider.autoDispose<int>((ref) => 0);

final selectedCategoryFromScrollProvider =
    StateProvider.autoDispose<dynamic>((ref) => 0);

final isModifiableProductProvider = StateProvider<bool>((ref) => false);

final productHasToppingsProvider = StateProvider<bool>((ref) => false);

final selectedProductIDProvider = StateProvider<int?>((ref) => null);

final itemSizeProvider = StateProvider<int>((ref) => 0);

final editOrderProvider = StateProvider<bool>((ref) => false);

final itemKeyProvider = StateProvider<String>((ref) => '');

final itemQuantityProvider = StateNotifierProvider<SelectItemQuantity, int>(
    (ref) => SelectItemQuantity());

final daysQuantityProvider = StateNotifierProvider<SelectDaysQuantity, int>(
    (ref) => SelectDaysQuantity());

final animatedListKeyProvider =
    Provider.autoDispose<GlobalKey<AnimatedListState>>(
        (ref) => GlobalKey<AnimatedListState>());

final currentIngredientIDProvider = StateProvider<int?>((ref) => null);

final currentIngredientIndexProvider = StateProvider<int?>((ref) => null);

final isScheduledProvider = StateProvider<bool>((ref) => false);

final favoriteItemNameProvider = StateProvider<String>((ref) => '');

final currentIngredientExtraChargeProvider =
    StateProvider<bool>((ref) => false);

final currentIngredientBlendedProvider = StateProvider<int>((ref) => 0);

final currentIngredientToppingProvider = StateProvider<int>((ref) => 0);

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

  add(int ingredient) {
    if (state.length == 3) {
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

  increment() {
    HapticFeedback.lightImpact();
    state = state + 1;
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

class SelectDaysQuantity extends StateNotifier<int> {
  SelectDaysQuantity() : super(1);

  increment() {
    HapticFeedback.lightImpact();
    if (state == 5) {
      state = state;
    } else {
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
    HapticFeedback.lightImpact();
    state = state + 1;
  }

  decrement() {
    if (state < 1) {
      return state = 0;
    } else {
      HapticFeedback.lightImpact();
      return state = state - 1;
    }
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
      {required List<dynamic> ingredients,
      required int index,
      required bool isExtraCharge,
      required WidgetRef ref,
      required UserModel user,
      int? blended,
      int? topping}) {
    final animatedListKey = ref.watch(animatedListKeyProvider);
    HapticFeedback.lightImpact();
    var newList = [
      ...state,
      {
        'id': ingredients[index].id,
        'amount': 1,
        'isExtraCharge': isExtraCharge,
        'price': ((ingredients[index].price * ((blended ?? 1) + (topping ?? 0)))
            .toStringAsFixed(2)),
        'memberPrice': ((ingredients[index].memberPrice *
                ((blended ?? 1) + (topping ?? 0)))
            .toStringAsFixed(2)),
        'blended': blended ?? 0,
        'topping': topping ?? 0,
      }
    ];
    newList.sort((a, b) => a['id'].compareTo(b['id']));
    animatedListKey.currentState!.insertItem(
      newList.indexWhere((element) => element['id'] == ingredients[index].id),
      duration: const Duration(milliseconds: 500),
    );

    state = newList;
  }

  removeIngredient(
      int ingredient, WidgetRef ref, List<dynamic> selectedIngredients) {
    HapticFeedback.lightImpact();
    final animatedListKey = ref.watch(animatedListKeyProvider);

    animatedListKey.currentState!.removeItem(
      selectedIngredients.indexWhere((element) => element['id'] == ingredient),
      (context, animation) => SizeTransition(
        axis: Axis.horizontal,
        axisAlignment: 1,
        sizeFactor: animation,
        child: const AnimatedListCard(),
      ),
    );
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

      for (var i = 0; i < totalItemsAdded; i++) {
        animatedListKey.currentState!.insertItem(
          0,
          duration: const Duration(milliseconds: 500),
        );
      }
    } else {
      int totalItemsRemoved =
          selectedIngredients.length - standardIngredients.length;
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
    };

    calculateExtraChargeAmount() {
      HapticFeedback.lightImpact();
      if (blended != null && topping != null) {
        return blended + topping;
      } else if (selectedIngredients[index]['amount'] < 1) {
        return 1;
      } else if (selectedIngredients[index]['amount'] == 1) {
        return 2;
      } else {
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
        'price': ((price * calculateExtraChargeAmount())).toStringAsFixed(2),
        'memberPrice':
            ((memberPrice * calculateExtraChargeAmount())).toStringAsFixed(2),
        'blended': blended,
        'topping': topping,
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
    };
    if (isExtraCharge) {
      newElement = {
        'id': selectedIngredients[index]['id'],
        'amount': calculateChargedAmount(),
        'price': ((price * calculateChargedAmount())).toStringAsFixed(2),
        'memberPrice':
            ((memberPrice * calculateChargedAmount())).toStringAsFixed(2),
      };
    } else {
      newElement = {
        'id': selectedIngredients[index]['id'],
        'amount': calculateNonChargedAmount(),
        'price': 0.toStringAsFixed(2),
        'memberPrice': 0.toStringAsFixed(2),
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

      return element['productID'] == item['productID'] &&
          element['itemSize'] == item['itemSize'] &&
          element['daysQuantity'] == item['daysQuantity'] &&
          (item['selectedIngredients'].isEmpty || selectedIngredientsEqual) &&
          (item['selectedToppings'].isEmpty || selectedToppingsEqual) &&
          selectedAllergiesEqual;
    });

    if (state.isEmpty || product.isEmpty) {
      state = [...state, item];
    } else {
      product.first['itemQuantity'] =
          product.first['itemQuantity'] + item['itemQuantity'];
      product.first['daysQuantity'] =
          product.first['isScheduled'] ? item['daysQuantity'] : 1;
      product.first['itemSize'] = item['itemSize'];
      state = [...state];
    }
  }

  editItem(WidgetRef ref, Map<String, dynamic> item) {
    HapticFeedback.lightImpact();
    final currentOrder = ref.watch(currentOrderItemsProvider);
    final currentOrderIndex = ref.watch(currentOrderItemsIndexProvider);
    currentOrder[currentOrderIndex]['itemQuantity'] = item['itemQuantity'];
    currentOrder[currentOrderIndex]['daysQuantity'] =
        currentOrder[currentOrderIndex]['isScheduled']
            ? item['daysQuantity']
            : 1;
    currentOrder[currentOrderIndex]['itemSize'] = item['itemSize'];
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
    int daysQuantity = item['daysQuantity'];
    int totalMaps = itemQuantity * daysQuantity;

    List<Map<String, dynamic>> maps = List.generate(
        totalMaps,
        (_) => {
              'price': item['price'],
              'memberPrice': item['memberPrice'],
              'points': item['points'],
              'itemKey': item['itemKey'],
              'productID': item['productID'],
              'itemQuantity': 1,
              'daysQuantity': 1
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
