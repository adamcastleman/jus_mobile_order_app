import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/spacing_widgets.dart';
import 'package:jus_mobile_order_app/Models/product_model.dart';

import '../../Providers/product_providers.dart';

class OrderTileSizeDisplay extends ConsumerWidget {
  final ProductModel currentProduct;
  final int orderIndex;
  const OrderTileSizeDisplay(
      {required this.currentProduct, required this.orderIndex, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    TextStyle style = const TextStyle(fontSize: 13);
    final currentOrder = ref.watch(currentOrderItemsProvider);
    if (!currentProduct.isScheduled &&
        (!currentProduct.isModifiable && !currentProduct.hasToppings)) {
      return const SizedBox();
    } else if (currentProduct.isScheduled) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Spacing().vertical(4),
          Text(
            'Quantity: ${currentOrder[orderIndex]['itemQuantity']}',
            style: style,
          ),
          Text(
            'Number of Days: ${currentOrder[orderIndex]['daysQuantity'] ?? ''}',
            style: style,
          ),
        ],
      );
    } else {
      return Column(
        children: [
          Text(
            '${currentProduct.price[currentOrder[orderIndex]['itemSize']]['name'] ?? ''}',
            style: style,
          )
        ],
      );
    }
  }
}
