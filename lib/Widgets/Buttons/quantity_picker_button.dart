import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Providers/product_providers.dart';

class QuantityPickerButton extends ConsumerWidget {
  final bool daysPicker;
  const QuantityPickerButton({required this.daysPicker, super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quantity = ref.watch(itemQuantityProvider);
    final days = ref.watch(daysQuantityProvider);
    return Row(
      children: [
        IconButton(
          icon: const Icon(CupertinoIcons.minus_circled),
          iconSize: 26,
          onPressed: () {
            daysPicker
                ? ref.read(daysQuantityProvider.notifier).decrement()
                : ref.read(itemQuantityProvider.notifier).decrement();
          },
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            '${daysPicker ? days : quantity}',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ),
        IconButton(
          icon: const Icon(CupertinoIcons.plus_circle),
          iconSize: 26,
          onPressed: () {
            daysPicker
                ? ref.read(daysQuantityProvider.notifier).increment()
                : ref.read(itemQuantityProvider.notifier).increment();
          },
        ),
      ],
    );
  }
}
