import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Providers/product_providers.dart';

class OrderTileDisplayQuantity extends ConsumerWidget {
  final int orderIndex;
  const OrderTileDisplayQuantity({required this.orderIndex, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentOrder = ref.watch(currentOrderItemsProvider);
    if (currentOrder[orderIndex]['itemQuantity'] == 1) {
      return const SizedBox();
    } else {
      return Text(
        'x${currentOrder[orderIndex]['itemQuantity']}',
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      );
    }
  }
}
