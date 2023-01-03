import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Providers/product_providers.dart';

class QuantityPickerButton extends ConsumerWidget {
  const QuantityPickerButton({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quantity = ref.watch(itemQuantityProvider);
    return Row(
      children: [
        IconButton(
          icon: const Icon(CupertinoIcons.minus_circled),
          iconSize: 26,
          onPressed: () {
            ref.read(itemQuantityProvider.notifier).decrement();
          },
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            '$quantity',
            style: Theme.of(context).textTheme.headline5,
          ),
        ),
        IconButton(
          icon: const Icon(CupertinoIcons.plus_circle),
          iconSize: 26,
          onPressed: () {
            ref.read(itemQuantityProvider.notifier).increment();
          },
        ),
      ],
    );
  }
}
