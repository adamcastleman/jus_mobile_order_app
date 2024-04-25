import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/enums.dart';
import 'package:jus_mobile_order_app/Helpers/pricing.dart';
import 'package:jus_mobile_order_app/Providers/product_providers.dart';
import 'package:jus_mobile_order_app/Providers/stream_providers.dart';

class DisplayPremiumIngredientPrices extends ConsumerWidget {
  final int index;
  const DisplayPremiumIngredientPrices({required this.index, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider).value!;
    final selectedIngredients = ref.watch(selectedIngredientsProvider);

    double pricePerUnit =
        double.tryParse(selectedIngredients[index]['price'].toString()) ?? 0;
    int amount =
        int.tryParse(selectedIngredients[index]['amount'].toString()) ?? 0;
    double totalPrice = pricePerUnit * amount;

    String formattedPrice = totalPrice.toStringAsFixed(2);

    if ((user.uid == null || user.subscriptionStatus?.isNotActive == true) &&
        totalPrice != 0) {
      return Text(
        '\$${PricingHelpers.formatAsCurrency(double.parse(formattedPrice) / 100)}',
        style: const TextStyle(fontSize: 11),
      );
    } else {
      return const SizedBox();
    }
  }
}
