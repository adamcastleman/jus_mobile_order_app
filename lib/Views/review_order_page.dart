import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/divider.dart';
import 'package:jus_mobile_order_app/Helpers/spacing_widgets.dart';
import 'package:jus_mobile_order_app/Helpers/utilities.dart';
import 'package:jus_mobile_order_app/Models/user_model.dart';
import 'package:jus_mobile_order_app/Providers/product_providers.dart';
import 'package:jus_mobile_order_app/Providers/stream_providers.dart';
import 'package:jus_mobile_order_app/Providers/theme_providers.dart';
import 'package:jus_mobile_order_app/Views/empty_bag_page.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/checkout_button.dart';
import 'package:jus_mobile_order_app/Widgets/General/category_display_widget.dart';
import 'package:jus_mobile_order_app/Widgets/General/total_price.dart';
import 'package:jus_mobile_order_app/Widgets/Headers/sheet_header.dart';
import 'package:jus_mobile_order_app/Widgets/Lists/display_order_list.dart';
import 'package:jus_mobile_order_app/Widgets/Tiles/selected_location_tile.dart';
import 'package:jus_mobile_order_app/constants.dart';

class ReviewOrderPage extends ConsumerWidget {
  const ReviewOrderPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider).value ?? const UserModel();
    final currentOrder = ref.watch(currentOrderItemsProvider);
    if (currentOrder.isEmpty) {
      return const EmptyBagPage();
    } else {
      return Container(
        color: ref.watch(backgroundColorProvider),
        padding: PlatformUtils.isIOS() || PlatformUtils.isAndroid()
            ? EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.01)
            : const EdgeInsets.only(top: 20.0),
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.symmetric(horizontal: 22.0),
          children: [
            const SheetHeader(title: 'Review order', showCloseButton: false),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CategoryWidget(
                    text: 'Location',
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 30.0),
                    child: SelectedLocationTile(
                      isEndDrawerOpen:
                          PlatformUtils.isIOS() || PlatformUtils.isAndroid()
                              ? false
                              : AppConstants
                                  .scaffoldKey.currentState!.isEndDrawerOpen,
                    ),
                  ),
                  const CategoryWidget(
                    text: 'Your Order',
                  ),
                  const DisplayOrderList(),
                  JusDivider.thick(),
                  const TotalPrice(),
                  Spacing.vertical(50),
                  CheckoutButton(
                    user: user,
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }
  }
}
