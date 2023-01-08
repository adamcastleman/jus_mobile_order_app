import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Providers/location_providers.dart';
import 'package:jus_mobile_order_app/Providers/navigation_providers.dart';
import 'package:jus_mobile_order_app/Views/choose_location_page.dart';
import 'package:jus_mobile_order_app/Widgets/Helpers/modal_bottom_sheets.dart';
import 'package:jus_mobile_order_app/Widgets/Helpers/permission_handler.dart';

class BottomNavBar extends ConsumerWidget {
  const BottomNavBar({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      selectedFontSize: 14,
      unselectedFontSize: 14,
      currentIndex: ref.watch(bottomNavigationProvider),
      onTap: (selected) async {
        if (selected == 2 && ref.read(selectedLocationID) == 0) {
          await HandlePermissions(context, ref).locationPermission();
          ModalBottomSheet().fullScreen(
              context: context,
              builder: (BuildContext context) => const ChooseLocationPage());
        }
        ref.read(bottomNavigationProvider.notifier).state = selected;
      },
      items: const [
        BottomNavigationBarItem(
            icon: Padding(
                padding: EdgeInsets.symmetric(vertical: 6.0),
                child: Icon(FontAwesomeIcons.house)),
            label: 'Home'),
        BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.symmetric(vertical: 6.0),
              child: Icon(
                FontAwesomeIcons.qrcode,
              ),
            ),
            label: 'Scan'),
        BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.symmetric(vertical: 6.0),
              child: Icon(FontAwesomeIcons.bagShopping),
            ),
            label: 'Order'),
        BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.symmetric(vertical: 6.0),
              child: Icon(FontAwesomeIcons.cartShopping),
            ),
            label: 'Cart'),
        BottomNavigationBarItem(
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
