import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Widgets/Lists/category_selector.dart';
import 'package:jus_mobile_order_app/Widgets/Lists/taxable_grouped_items.dart';
import 'package:jus_mobile_order_app/Widgets/Tiles/selected_location_tile.dart';

class OrderPage extends ConsumerWidget {
  const OrderPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Column(
      children: [
        SelectedLocationTile(),
        Padding(
          padding: EdgeInsets.only(top: 8.0, bottom: 18.0),
          child: CategorySelector(),
        ),
        Expanded(
          child: ListOfTaxableProductsByGroup(),
        ),
      ],
    );
  }
}
