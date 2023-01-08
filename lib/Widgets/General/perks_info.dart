import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Models/product_model.dart';

class PerksInfo extends ConsumerWidget {
  final ProductModel product;
  const PerksInfo({required this.product, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        product.perks.isEmpty
            ? const SizedBox()
            : Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: Text(
                  product.perks,
                  style: const TextStyle(fontSize: 18),
                ),
              )
      ],
    );
  }
}
