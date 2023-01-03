import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Providers/product_providers.dart';

class MultiUseIngredientSelectionCards extends ConsumerWidget {
  final int index;
  const MultiUseIngredientSelectionCards({required this.index, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        2,
        (optionsIndex) => InkWell(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 8.0),
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: Colors.black, width: 0.5),
              color: determineBoxColor(optionsIndex, ref),
            ),
            child: Center(
              child: Text(optionsIndex == 0 ? 'Yes' : 'No'),
            ),
          ),
          onTap: () {
            index == 0
                ? ref.read(currentIngredientBlendedProvider.notifier).state =
                    optionsIndex
                : ref.read(currentIngredientToppingProvider.notifier).state =
                    optionsIndex;
          },
        ),
      ),
    );
  }

  determineBoxColor(int optionsIndex, WidgetRef ref) {
    final isBlended = ref.watch(currentIngredientBlendedProvider);
    final isTopping = ref.watch(currentIngredientToppingProvider);
    if (index == 0 && isBlended == optionsIndex) {
      return Colors.blueGrey[100];
    } else if (index == 1 && isTopping == optionsIndex) {
      return Colors.blueGrey[100];
    } else {
      return Colors.white;
    }
  }
}
