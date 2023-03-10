import 'package:badges/badges.dart' as badge;
import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/error.dart';
import 'package:jus_mobile_order_app/Helpers/loading.dart';
import 'package:jus_mobile_order_app/Helpers/locations.dart';
import 'package:jus_mobile_order_app/Helpers/payments.dart';
import 'package:jus_mobile_order_app/Helpers/scan.dart';
import 'package:jus_mobile_order_app/Helpers/time.dart';
import 'package:jus_mobile_order_app/Models/user_model.dart';
import 'package:jus_mobile_order_app/Providers/location_providers.dart';
import 'package:jus_mobile_order_app/Providers/navigation_providers.dart';
import 'package:jus_mobile_order_app/Providers/payments_providers.dart';
import 'package:jus_mobile_order_app/Providers/product_providers.dart';
import 'package:jus_mobile_order_app/Providers/scan_providers.dart';
import 'package:jus_mobile_order_app/Providers/stream_providers.dart';

class BottomNavBar extends HookConsumerWidget {
  const BottomNavBar({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentOrder = ref.watch(currentOrderItemsProvider);
    final currentUser = ref.watch(currentUserProvider);
    num totalItemAmount = 0;
    for (var item in currentOrder) {
      totalItemAmount = totalItemAmount + item['itemQuantity'];
    }
    return currentUser.when(
      error: (e, _) => ShowError(error: e.toString()),
      loading: () => const Loading(),
      data: (user) => BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedFontSize: 14,
        unselectedFontSize: 14,
        currentIndex: ref.watch(bottomNavigationProvider),
        onTap: (selected) {
          handleNavigation(context, user, ref, selected);
        },
        items: [
          const BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.symmetric(vertical: 6.0),
                child: Icon(FontAwesomeIcons.house),
              ),
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
                            : 12,
                  ),
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
      ),
    );
  }

  handleNavigation(
      BuildContext context, UserModel user, WidgetRef ref, int selected) {
    switch (selected) {
      case 0:
        {
          ref.read(qrTimerProvider.notifier).cancelTimer();
        }
        break;
      case 1:
        {
          ref.read(qrTimestampProvider.notifier).state = Time().now(ref);
          user.uid == null
              ? null
              : ref.read(selectedCreditCardProvider.notifier).state =
                  PaymentsHelpers(ref: ref).constructDefaultPayment();
          ScanHelpers(ref).scanAndPayMap();
          ScanHelpers(ref).scanOnlyMap();
          ref.read(qrTimerProvider.notifier).startTimer(ref);
        }
        break;
      case 2:
        {
          ref.read(qrTimerProvider.notifier).cancelTimer();
          if (ref.read(selectedLocationProvider) == null) {
            LocationHelper().chooseLocation(context, ref);
          }
        }
        break;
      case 3:
        {
          ref.read(qrTimerProvider.notifier).cancelTimer();
        }
        break;
      case 4:
        {
          ref.read(qrTimerProvider.notifier).cancelTimer();
        }
        break;
      default:
        ref.read(qrTimerProvider.notifier).cancelTimer();
    }

    ref.read(bottomNavigationProvider.notifier).state = selected;
  }
}
