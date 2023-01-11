import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Providers/stream_providers.dart';
import 'package:jus_mobile_order_app/Widgets/Helpers/loading.dart';
import 'package:jus_mobile_order_app/Widgets/Lists/category_selector.dart';
import 'package:jus_mobile_order_app/Widgets/Lists/grouped_order_list.dart';
import 'package:jus_mobile_order_app/Widgets/Tiles/selected_location_tile.dart';

class OrderPage extends ConsumerWidget {
  const OrderPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var products = ref.watch(taxableProductsProvider);

    return products.when(
      loading: () => const Loading(),
      error: (Object e, _) => Text(
        e.toString(),
      ),
      data: (data) => Column(
        children: const [
          SelectedLocationTile(),
          Padding(
            padding: EdgeInsets.only(top: 8.0, bottom: 18.0),
            child: CategorySelector(),
          ),
          Expanded(
            child: GroupedOrderList(),
          ),
        ],
      ),
    );
  }
}
