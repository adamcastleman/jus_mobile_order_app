import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Models/product_model.dart';
import 'package:jus_mobile_order_app/Providers/ProviderWidgets/product_quantity_limit_provider.dart';
import 'package:jus_mobile_order_app/Providers/product_providers.dart';

class QuantityPickerButton extends ConsumerWidget {
  final ProductModel product;
  final bool scheduledPicker;
  const QuantityPickerButton(
      {required this.product, required this.scheduledPicker, super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quantity = ref.watch(itemQuantityProvider);
    final scheduledQuantity = ref.watch(scheduledQuantityProvider);
    return ProductQuantityLimitProviderWidget(
      productUID: product.uid,
      builder: (quantityLimit) => Row(
        children: [
          IconButton(
            icon: const Icon(CupertinoIcons.minus_circled),
            iconSize: 26,
            onPressed: () {
              HapticFeedback.lightImpact();
              scheduledPicker
                  ? ref.read(scheduledQuantityProvider.notifier).decrement()
                  : ref.read(itemQuantityProvider.notifier).decrement();
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              '${scheduledPicker ? scheduledQuantity : quantity}',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
          IconButton(
            icon: const Icon(CupertinoIcons.plus_circle),
            iconSize: 26,
            onPressed: () {
              scheduledPicker
                  ? ref
                      .read(scheduledQuantityProvider.notifier)
                      .increment(quantityLimit.scheduledQuantityLimit)
                  : ref
                      .read(itemQuantityProvider.notifier)
                      .increment(quantityLimit.quantityLimit);
            },
          ),
        ],
      ),
    );
  }
}
