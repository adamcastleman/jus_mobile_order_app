import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Models/product_model.dart';
import 'package:jus_mobile_order_app/Providers/product_providers.dart';

class StandardIngredients {
  final WidgetRef ref;
  StandardIngredients({required this.ref});

  set(ProductModel product) {
    List<Map<String, dynamic>> newList = [];
    for (var ingredient in product.ingredients) {
      newList.add({
        'id': ingredient,
        'amount': 1,
        'isExtraCharge': false,
        'price': 0.toStringAsFixed(2),
        'memberPrice': 0.toStringAsFixed(2),
        'blended': 0,
        'topping': 0,
      });
    }
    newList.sort((a, b) => a['id'].compareTo(b['id']));
    ref.read(standardIngredientsProvider.notifier).state = newList;
    ref.read(isModifiableProductProvider.notifier).state = product.isModifiable;
    ref.read(productHasToppingsProvider.notifier).state = product.hasToppings;
  }

  add() {
    final selectedIngredients = ref.watch(selectedIngredientsProvider);
    final standardIngredients = ref.watch(standardIngredientsProvider);
    selectedIngredients.isEmpty
        ? ref
            .read(selectedIngredientsProvider.notifier)
            .addIngredients(standardIngredients)
        : null;
  }
}
