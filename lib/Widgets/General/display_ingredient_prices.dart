import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Providers/ProviderWidgets/user_provider_widget.dart';
import 'package:jus_mobile_order_app/Providers/product_providers.dart';

class DisplayPremiumIngredientPrices extends ConsumerWidget {
  final int index;
  const DisplayPremiumIngredientPrices({required this.index, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIngredients = ref.watch(selectedIngredientsProvider);
    return UserProviderWidget(builder: (user) {
      if ((user.uid == null || !user.isActiveMember!) &&
          selectedIngredients[index]['price'] != 0.toStringAsFixed(2)) {
        return Text(
          '\$${(double.parse(selectedIngredients[index]['price']) / 100).toStringAsFixed(2)}',
          style: const TextStyle(fontSize: 11),
        );
      } else {
        return const SizedBox();
      }
    });
  }
}
