import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/divider.dart';
import 'package:jus_mobile_order_app/Providers/product_providers.dart';
import 'package:jus_mobile_order_app/Widgets/Tiles/order_tile.dart';

class DisplayOrderList extends ConsumerWidget {
  const DisplayOrderList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentOrder = ref.watch(currentOrderItemsProvider);
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      primary: false,
      itemCount: currentOrder.length,
      separatorBuilder: (context, index) => JusDivider.thin(),
      itemBuilder: (context, index) => OrderTile(
        orderIndex: index,
      ),
    );
  }
}
