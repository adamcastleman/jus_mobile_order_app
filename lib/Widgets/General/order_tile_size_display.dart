import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/spacing_widgets.dart';
import 'package:jus_mobile_order_app/Models/product_model.dart';
import 'package:jus_mobile_order_app/Providers/ProviderWidgets/product_quantity_limit_provider.dart';
import 'package:jus_mobile_order_app/constants.dart';

import '../../Providers/product_providers.dart';

class OrderTileSizeDisplay extends ConsumerWidget {
  final ProductModel currentProduct;
  final int orderIndex;
  const OrderTileSizeDisplay(
      {required this.currentProduct, required this.orderIndex, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    TextStyle style = const TextStyle(fontSize: 13);
    final currentOrder = ref.watch(currentOrderItemsProvider);
    final nonMemberProductVariation = currentProduct.variations
        .where(
            (element) => element['customerType'] == AppConstants.nonMemberType)
        .toList();
    final itemSizeName =
        nonMemberProductVariation[currentOrder[orderIndex]['itemSize']]['name'];
    if (!currentProduct.isScheduled &&
        (!currentProduct.isModifiable && !currentProduct.hasToppings)) {
      return const SizedBox();
    } else if (currentProduct.isScheduled) {
      return ProductQuantityLimitProviderWidget(
        productUID: currentProduct.uid,
        builder: (quantityLimit) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Spacing.vertical(4),
            Text(
              'Quantity: ${currentOrder[orderIndex]['itemQuantity']}',
              style: style,
            ),
            Text(
              '${quantityLimit.scheduledProductDescriptor}: ${currentOrder[orderIndex]['scheduledQuantity'] ?? ''}',
              style: style,
            ),
          ],
        ),
      );
    } else {
      return Column(
        children: [
          Text(
            '${itemSizeName ?? ''}',
            style: style,
          )
        ],
      );
    }
  }
}
