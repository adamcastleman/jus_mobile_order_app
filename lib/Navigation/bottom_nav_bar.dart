import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/navigation.dart';
import 'package:jus_mobile_order_app/Helpers/scan.dart';
import 'package:jus_mobile_order_app/Providers/controller_providers.dart';
import 'package:jus_mobile_order_app/Providers/location_providers.dart';
import 'package:jus_mobile_order_app/Providers/navigation_providers.dart';
import 'package:jus_mobile_order_app/Widgets/Icons/bag_icon.dart';

class BottomNavBar extends HookConsumerWidget {
  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pageController = ref.watch(bottomNavigationPageControllerProvider);
    final currentIndex = ref.watch(bottomNavigationProvider);

    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      selectedFontSize: 14,
      unselectedFontSize: 14,
      currentIndex: currentIndex,
      onTap: (selected) {
        _handleNavigation(context, ref, selected, pageController);
      },
      items: _buildBottomNavBarItems(ref, currentIndex),
    );
  }

  List<BottomNavigationBarItem> _buildBottomNavBarItems(
      WidgetRef ref, int currentIndex) {
    return [
      _navBarItem(CupertinoIcons.house, 'Home'),
      _navBarItem(CupertinoIcons.barcode_viewfinder, 'Scan'),
      _navBarItem(CupertinoIcons.drop, 'Order'),
      _navBarItemCustomWidget(const BagIcon(), 'Bag'),
      _navBarItem(CupertinoIcons.person_alt_circle, 'Profile'),
    ];
  }

  BottomNavigationBarItem _navBarItem(IconData icon, String label) {
    return BottomNavigationBarItem(
      icon: Icon(icon, size: 35), // Adjust icon size as needed
      label: label,
    );
  }

  BottomNavigationBarItem _navBarItemCustomWidget(Widget icon, String label) {
    return BottomNavigationBarItem(
      icon: icon, // Directly use the custom widget
      label: label,
    );
  }

  void _handleNavigation(BuildContext context, WidgetRef ref, int selected,
      PageController pageController) async {
    HapticFeedback.lightImpact();
    _updateNavigationState(context, ref, selected);
    pageController.jumpToPage(selected);
  }

  void _updateNavigationState(
      BuildContext context, WidgetRef ref, int selected) {
    ScanHelpers.cancelQrTimer(ref);
    _executePageSpecificActions(context, ref, selected);
    updateBottomNavigation(ref, selected);
  }

  void _executePageSpecificActions(
      BuildContext context, WidgetRef ref, int selected) {
    switch (selected) {
      case 1:
        ScanHelpers.handleScanAndPayPageInitializers(ref);
        break;
      case 2:
        if (ref.read(selectedLocationProvider).uid.isEmpty) {
          NavigationHelpers().navigateToLocationPage(context, ref);
        }
        break;
      default:
        // Other cases can be handled here if needed
        break;
    }
  }

  void updateBottomNavigation(WidgetRef ref, int selected) {
    ref.read(bottomNavigationProvider.notifier).state = selected;
  }
}
