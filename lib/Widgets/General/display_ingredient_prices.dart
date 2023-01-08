import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Providers/product_providers.dart';
import 'package:jus_mobile_order_app/Providers/stream_providers.dart';
import 'package:jus_mobile_order_app/Widgets/Helpers/error.dart';
import 'package:jus_mobile_order_app/Widgets/Helpers/loading.dart';

class DisplayPremiumIngredientPrices extends ConsumerWidget {
  final int index;
  const DisplayPremiumIngredientPrices({required this.index, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIngredients = ref.watch(selectedIngredientsProvider);
    final currentUser = ref.watch(currentUserProvider);
    return currentUser.when(
        loading: () => const Loading(),
        error: (e, _) => ShowError(
              error: e.toString(),
            ),
        data: (user) {
          if (currentUser.value?.uid == null &&
              selectedIngredients[index]['price'] != 0.toStringAsFixed(2)) {
            return Text(
              '\$${selectedIngredients[index]['price']}',
              style: const TextStyle(fontSize: 11),
            );
          } else if (currentUser.value?.uid == null &&
              selectedIngredients[index]['price'] == 0.toStringAsFixed(2)) {
            return const SizedBox();
          } else if (user.isActiveMember!) {
            return const SizedBox();
          } else if (selectedIngredients[index]['price'] ==
              0.toStringAsFixed(2)) {
            return const SizedBox();
          } else {
            return Text(
              '\$${selectedIngredients[index]['price']}',
              style: const TextStyle(fontSize: 11),
            );
          }
        });
  }
}
