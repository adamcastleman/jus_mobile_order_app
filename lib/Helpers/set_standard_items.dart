import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Models/product_model.dart';
import 'package:jus_mobile_order_app/Providers/product_providers.dart';

class StandardItems {
  final WidgetRef ref;
  StandardItems({required this.ref});

  set(ProductModel product) {
    List<Map<String, dynamic>> newList = [];
    for (var ingredient in product.ingredients) {
      newList.add({
        'id': ingredient,
      });
    }
    ref.read(standardItemsProvider.notifier).state = newList;
    ref.read(isModifiableProductProvider.notifier).state = product.isModifiable;
  }
}
