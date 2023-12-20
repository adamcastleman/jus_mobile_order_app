import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/enums.dart';
import 'package:jus_mobile_order_app/Helpers/locations.dart';
import 'package:jus_mobile_order_app/Helpers/scan.dart';
import 'package:jus_mobile_order_app/Helpers/time.dart';
import 'package:jus_mobile_order_app/Models/user_model.dart';
import 'package:jus_mobile_order_app/Providers/controller_providers.dart';
import 'package:jus_mobile_order_app/Providers/location_providers.dart';
import 'package:jus_mobile_order_app/Providers/navigation_providers.dart';
import 'package:jus_mobile_order_app/Providers/payments_providers.dart';
import 'package:jus_mobile_order_app/Providers/scan_providers.dart';
import 'package:jus_mobile_order_app/Providers/stream_providers.dart';
import 'package:jus_mobile_order_app/Widgets/Icons/bag_icon.dart';

class BottomNavBar extends HookConsumerWidget {
  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider).value ?? const UserModel();
    final pageController = ref.watch(bottomNavigationPageControllerProvider);

    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      selectedFontSize: 14,
      unselectedFontSize: 14,
      currentIndex: ref.watch(bottomNavigationProvider),
      onTap: (selected) {
        HapticFeedback.lightImpact();
        handleNavigation(context, user, ref, selected);
        pageController.jumpToPage(selected);
      },
      items: [
        const BottomNavigationBarItem(
          icon: Padding(
            padding: EdgeInsets.only(top: 10.0, bottom: 3.0),
            child: Icon(
              CupertinoIcons.house,
              size: 33,
            ),
          ),
          label: 'Home',
        ),
        const BottomNavigationBarItem(
          icon: Padding(
            padding: EdgeInsets.only(top: 10.0, bottom: 2.0),
            child: Icon(
              CupertinoIcons.barcode_viewfinder,
              size: 35,
            ),
          ),
          label: 'Scan',
        ),
        BottomNavigationBarItem(
          icon: Padding(
            padding: const EdgeInsets.only(bottom: 2.0),
            child: Image.asset(
              ref.read(bottomNavigationProvider) == 2
                  ? 'assets/smoothie_full_icon.png'
                  : 'assets/smoothie_empty_icon.png',
              scale: 2.2,
            ),
          ),
          label: 'Order',
        ),
        const BottomNavigationBarItem(
          icon: Padding(
            padding: EdgeInsets.only(top: 10.0, bottom: 2.0),
            child: BagIcon(),
          ),
          label: 'Bag',
        ),
        const BottomNavigationBarItem(
          icon: Padding(
            padding: EdgeInsets.only(top: 10.0, bottom: 4.0),
            child: Icon(
              CupertinoIcons.person_alt_circle,
              size: 35,
            ),
          ),
          label: 'Profile',
        ),
      ],
    );
  }

  void handleNavigation(
      BuildContext context, UserModel user, WidgetRef ref, int selected) {
    cancelQrTimer(ref);
    switch (selected) {
      case 0:
        break;
      case 1:
        handleScanPageInitializers(ref);
        break;
      case 2:
        if (ref.read(selectedLocationProvider) == null) {
          LocationHelper().chooseLocation(context, ref);
        }
        break;
      case 3:
        break;
      case 4:
        break;
      default:
    }
    updateBottomNavigation(ref, selected);
  }

  void cancelQrTimer(WidgetRef ref) {
    ref.read(qrTimerProvider.notifier).cancelTimer();
  }

  void handleScanPageInitializers(WidgetRef ref) {
    ref.read(pageTypeProvider.notifier).state = PageType.selectPaymentMethod;
    ref.read(qrTimestampProvider.notifier).state = Time().now(ref);
    ScanHelpers(ref).scanAndPayMap();
    ScanHelpers(ref).scanOnlyMap();
    ref.read(qrTimerProvider.notifier).startTimer(ref);
  }

  void updateBottomNavigation(WidgetRef ref, int selected) {
    ref.read(bottomNavigationProvider.notifier).state = selected;
  }
}
