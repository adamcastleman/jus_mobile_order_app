import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Models/ingredient_model.dart';
import 'package:jus_mobile_order_app/Providers/product_providers.dart';

class MultiUseIngredientQuantityPicker extends ConsumerWidget {
  final int index;
  final IngredientModel currentIngredient;
  const MultiUseIngredientQuantityPicker(
      {required this.index, required this.currentIngredient, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final blendedQuantity =
        ref.watch(extraChargeBlendedIngredientQuantityProvider);
    final toppedQuantity =
        ref.watch(extraChargeToppedIngredientQuantityProvider);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: const Icon(CupertinoIcons.minus_circle),
          onPressed: () {
            HapticFeedback.lightImpact();
            determineDecrementItem(ref);
          },
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: Text(
            '${index == 0 ? blendedQuantity : toppedQuantity}',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ),
        IconButton(
          icon: const Icon(CupertinoIcons.plus_circle),
          onPressed: () {
            determineIncrementItem(ref);
          },
        ),
      ],
    );
  }

  determineIncrementItem(WidgetRef ref) {
    if (index == 0) {
      ref
          .read(extraChargeBlendedIngredientQuantityProvider.notifier)
          .increment();
    } else {
      ref
          .read(extraChargeToppedIngredientQuantityProvider.notifier)
          .increment();
    }
  }

  determineDecrementItem(WidgetRef ref) {
    if (index == 0) {
      ref
          .read(extraChargeBlendedIngredientQuantityProvider.notifier)
          .decrement();
    } else {
      ref
          .read(extraChargeToppedIngredientQuantityProvider.notifier)
          .decrement();
    }
  }
}
