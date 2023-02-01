import 'package:badges/badges.dart' as badge;
import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Providers/location_providers.dart';
import 'package:jus_mobile_order_app/Providers/navigation_providers.dart';
import 'package:jus_mobile_order_app/Providers/product_providers.dart';
import 'package:jus_mobile_order_app/Widgets/Helpers/locations.dart';

class BottomNavBar extends ConsumerWidget {
  const BottomNavBar({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentOrder = ref.watch(currentOrderItemsProvider);
    num totalItemAmount = 0;
    for (var item in currentOrder) {
      totalItemAmount = totalItemAmount + item['itemQuantity'];
    }
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      selectedFontSize: 14,
      unselectedFontSize: 14,
      currentIndex: ref.watch(bottomNavigationProvider),
      onTap: (selected) {
        if (selected == 2 && ref.read(selectedLocationProvider) == null) {
          LocationHelper().chooseLocation(context, ref);
        }
        ref.read(bottomNavigationProvider.notifier).state = selected;
      },
      items: [
        const BottomNavigationBarItem(
            icon: Padding(
                padding: EdgeInsets.symmetric(vertical: 6.0),
                child: Icon(FontAwesomeIcons.house)),
            label: 'Home'),
        const BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.symmetric(vertical: 6.0),
              child: Icon(
                FontAwesomeIcons.qrcode,
              ),
            ),
            label: 'Scan'),
        const BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.symmetric(vertical: 6.0),
              child: Icon(FontAwesomeIcons.bagShopping),
            ),
            label: 'Order'),
        BottomNavigationBarItem(
          icon: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6.0),
            child: badge.Badge(
              badgeStyle: const BadgeStyle(
                badgeColor: Colors.white,
                borderSide: BorderSide(color: Colors.black, width: 1),
                padding: EdgeInsets.all(6),
              ),
              key: const ValueKey(1),
              position: BadgePosition.topEnd(),
              showBadge: totalItemAmount == 0 ? false : true,
              badgeContent: Text(
                '$totalItemAmount',
                style: TextStyle(
                    fontSize: totalItemAmount > 9
                        ? 10
                        : totalItemAmount > 99
                            ? 8
                            : 12),
              ),
              child: const Icon(FontAwesomeIcons.cartShopping),
            ),
          ),
          label: 'Cart',
        ),
        const BottomNavigationBarItem(
          icon: Padding(
            padding: EdgeInsets.symmetric(vertical: 6.0),
            child: Icon(FontAwesomeIcons.user),
          ),
          label: 'Profile',
        ),
      ],
    );
  }
}
