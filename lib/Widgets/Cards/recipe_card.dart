import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Providers/product_providers.dart';
import 'package:jus_mobile_order_app/Widgets/Cards/modify_item_no_toppings_card.dart';
import 'package:jus_mobile_order_app/Widgets/Cards/modify_item_with_toppings_card.dart';

class RecipeCard extends ConsumerWidget {
  final int index;
  const RecipeCard({required this.index, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hasToppings = ref.watch(productHasToppingsProvider);

    if (hasToppings) {
      return ModifyItemWithToppingsCard(index: index);
    } else {
      return ModifyItemNoToppingsCard(
        index: index,
      );
    }
  }
}
