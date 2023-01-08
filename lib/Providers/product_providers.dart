import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Models/ingredient_model.dart';
import 'package:jus_mobile_order_app/Models/product_model.dart';
import 'package:jus_mobile_order_app/Models/user_model.dart';
import 'package:jus_mobile_order_app/Services/product_services.dart';
import 'package:jus_mobile_order_app/Widgets/Cards/animated_list_card.dart';

final taxableProductsProvider = StreamProvider<List<ProductModel>>(
    (ref) => ProductServices().taxableProducts);

final recommendedProductsProvider = StreamProvider<List<ProductModel>>(
    (ref) => ProductServices().recommendedProducts);

final categoryOrderProvider = StateProvider<int>((ref) => 0);

final selectedCategoryFromScrollProvider =
    StateProvider.autoDispose<dynamic>((ref) => 0);

final isModifiableProductProvider = StateProvider<bool>((ref) => false);

final productHasToppingsProvider = StateProvider<bool>((ref) => false);

final selectedSizeProvider = StateProvider.autoDispose<int>((ref) => 0);

final itemQuantityProvider =
    StateNotifierProvider.autoDispose<SelectItemQuantity, int>(
        (ref) => SelectItemQuantity());

final animatedListKeyProvider =
    Provider.autoDispose<GlobalKey<AnimatedListState>>(
        (ref) => GlobalKey<AnimatedListState>());

final currentIngredientIDProvider = StateProvider<int?>((ref) => null);

final currentIngredientIndexProvider = StateProvider<int?>((ref) => null);

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

final selectedAllergiesProvider =
    StateNotifierProvider.autoDispose<SelectedAllergies, List<int>>(
        (ref) => SelectedAllergies());

final selectedToppingsProvider =
    StateNotifierProvider.autoDispose<SelectedToppings, List<int>>(
        (ref) => SelectedToppings());

class SelectedToppings extends StateNotifier<List<int>> {
  SelectedToppings() : super([]);

  add(int ingredient) {
    if (state.length == 3) {
      state = state;
    } else {
      state = [...state, ingredient];
    }
  }

  remove(int ingredient) {
    List<int> newList = [...state];
    newList.removeWhere((element) => element == ingredient);
    state = newList;
  }
}

class SelectedAllergies extends StateNotifier<List<int>> {
  SelectedAllergies() : super([]);

  add(int ingredient) {
    state = [...state, ingredient];
  }

  remove(int ingredient) {
    List<int> newList = [...state];
    newList.removeWhere((element) => element == ingredient);
    state = newList;
  }
}

class SelectItemQuantity extends StateNotifier<int> {
  SelectItemQuantity() : super(1);

  increment() {
    state = state + 1;
  }

  decrement() {
    if (state < 2) {
      return state = 1;
    } else {
      return state = state - 1;
    }
  }
}

class SelectExtraChargeIngredientQuantity extends StateNotifier<int> {
  SelectExtraChargeIngredientQuantity() : super(0);

  increment() {
    state = state + 1;
  }

  decrement() {
    if (state < 1) {
      return state = 0;
    } else {
      return state = state - 1;
    }
  }
}

class ListOfIngredients extends StateNotifier<List<dynamic>> {
  ListOfIngredients() : super([]);

  addIngredients(List<Map<String, dynamic>> ingredients) {
    ingredients.sort((a, b) => a['id'].compareTo(b['id']));

    state = ingredients;
  }

  addIngredient(
      {required List<IngredientModel> ingredients,
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
        'amount': 1 + (blended ?? 0) + (topping ?? 0),
        'isExtraCharge': isExtraCharge,
        'price': ((ingredients[index].price *
                ((blended ?? 1) + (topping ?? 0)) /
                100)
            .toStringAsFixed(2)),
        'memberPrice': ((ingredients[index].memberPrice *
                ((blended ?? 1) + (topping ?? 0)) /
                100)
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
    HapticFeedback.lightImpact();
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
      if (blended != null && topping != null) {
        return blended + topping;
      } else {
        return selectedIngredients[index]['amount'] < 1
            ? 1
            : selectedIngredients[index]['amount'] == 1
                ? 2
                : selectedIngredients[index]['amount'] + 1;
      }
    }

    calculateNonChargedAmount() {
      return selectedIngredients[index]['amount'] < 1
          ? 1
          : selectedIngredients[index]['amount'] == 1
              ? 2
              : selectedIngredients[index]['amount'];
    }

    if (isExtraCharge) {
      newElement = {
        'id': selectedIngredients[index]['id'],
        'isExtraCharge': isExtraCharge,
        'amount': calculateExtraChargeAmount(),
        'price':
            ((price * calculateExtraChargeAmount()) / 100).toStringAsFixed(2),
        'memberPrice': ((memberPrice * calculateExtraChargeAmount()) / 100)
            .toStringAsFixed(2),
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
    HapticFeedback.lightImpact();
    final selectedIngredients = ref.watch(selectedIngredientsProvider);
    IngredientModel currentIngredient = ingredients
        .where((element) => element.id == selectedIngredients[index]['id'])
        .first;
    List newList = [...state];
    bool isExtraCharge = currentIngredient.isExtraCharge;
    int memberPrice = currentIngredient.memberPrice;
    int price = currentIngredient.price;
    calculateChargedAmount() {
      return selectedIngredients[index]['amount'] <= 2
          ? 1
          : selectedIngredients[index]['amount'] - 1;
    }

    calculateNonChargedAmount() {
      return selectedIngredients[index]['amount'] <= 1
          ? 0.5
          : selectedIngredients[index]['amount'] - 1;
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
        'price': ((price * calculateChargedAmount()) / 100).toStringAsFixed(2),
        'memberPrice':
            ((memberPrice * calculateChargedAmount()) / 100).toStringAsFixed(2),
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
