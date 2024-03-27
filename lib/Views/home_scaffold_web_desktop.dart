import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/enums.dart';
import 'package:jus_mobile_order_app/Helpers/utilities.dart';
import 'package:jus_mobile_order_app/Models/user_model.dart';
import 'package:jus_mobile_order_app/Navigation/end_drawer_web.dart';
import 'package:jus_mobile_order_app/Navigation/web_nav_bar.dart';
import 'package:jus_mobile_order_app/Providers/controller_providers.dart';
import 'package:jus_mobile_order_app/Providers/navigation_providers.dart';
import 'package:jus_mobile_order_app/Providers/stream_providers.dart';
import 'package:jus_mobile_order_app/Views/cleanse_page_web.dart';
import 'package:jus_mobile_order_app/Views/home_page_web.dart';
import 'package:jus_mobile_order_app/Views/location_page_web.dart';
import 'package:jus_mobile_order_app/Views/membership_information_page.dart';
import 'package:jus_mobile_order_app/Views/menu_page.dart';
import 'package:jus_mobile_order_app/Views/points_information_page.dart';
import 'package:jus_mobile_order_app/Views/scan_page.dart';
import 'package:jus_mobile_order_app/Widgets/Dialogs/paused_membership_banner.dart';
import 'package:jus_mobile_order_app/constants.dart';

class HomeScaffoldWeb extends ConsumerWidget {
  const HomeScaffoldWeb({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scaffoldKey = AppConstants.scaffoldKey;
    final user = ref.watch(currentUserProvider).value ?? const UserModel();
    final pageController = ref.watch(webNavigationPageControllerProvider);
    final drawerPage = ref.watch(drawerPageProvider);
    return Scaffold(
      key: scaffoldKey,
      endDrawer: EndDrawerWeb(
        child: drawerPage,
      ),
      appBar: PreferredSize(
        preferredSize: ResponsiveLayout.isMobileBrowser(context)
            ? Size.fromHeight(AppConstants.screenHeight * 0.05)
            : Size.fromHeight(AppConstants.screenHeight * 0.06),
        child: Material(
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 18.0),
            child: WebNavBar(
              user: user,
              scaffoldKey: scaffoldKey,
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          PageView(
            controller: pageController,
            physics: const NeverScrollableScrollPhysics(),
            onPageChanged: (value) {
              ref.read(webNavigationProvider.notifier).state = value;
            },
            children:  [
             const HomePageWeb(),
             const MenuPage(),
             const CleansePageWeb(),
             const MembershipInformationPage(),
             const LocationPageWeb(),
              ScanPage(ref: ref),
             const PointsInformationPage(showCloseButton: false),
            ],
          ),
          user.subscriptionStatus == SubscriptionStatus.paused
              ? const PausedMembershipBanner()
              : const SizedBox(),
        ],
      ),
    );
  }
}
