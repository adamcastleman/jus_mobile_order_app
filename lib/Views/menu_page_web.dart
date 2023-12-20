import 'package:flutter/material.dart';
import 'package:jus_mobile_order_app/Widgets/Lists/category_selector.dart';
import 'package:jus_mobile_order_app/Widgets/Lists/taxable_grouped_items.dart';
import 'package:jus_mobile_order_app/Widgets/Tiles/selected_location_tile.dart';

class MenuPageWeb extends StatelessWidget {
  const MenuPageWeb({super.key});

  @override
  Widget build(BuildContext context) {
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
