import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/utilities.dart';
import 'package:jus_mobile_order_app/Providers/theme_providers.dart';
import 'package:jus_mobile_order_app/Widgets/Lists/category_selector.dart';
import 'package:jus_mobile_order_app/Widgets/Lists/taxable_grouped_items.dart';
import 'package:jus_mobile_order_app/Widgets/Tiles/selected_location_tile.dart';
import 'package:jus_mobile_order_app/constants.dart';

class MenuPage extends ConsumerWidget {
  const MenuPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tileColor = ref.watch(darkGreenProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 8.0, bottom: 18.0),
          child: CategorySelector(),
        ),
        const Expanded(
          child: ListOfTaxableProductsByGroup(),
        ),
        SelectedLocationTile(
          tileColor: tileColor,
          textColor: Colors.white,
          loadingColor: Colors.white,
          isEndDrawerOpen: PlatformUtils.isIOS() || PlatformUtils.isAndroid()
              ? false
              : !AppConstants.scaffoldKey.currentState!.isEndDrawerOpen,
        ),
      ],
    );
  }
}
