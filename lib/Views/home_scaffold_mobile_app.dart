import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/enums.dart';
import 'package:jus_mobile_order_app/Models/user_model.dart';
import 'package:jus_mobile_order_app/Navigation/bottom_nav_bar.dart';
import 'package:jus_mobile_order_app/Providers/controller_providers.dart';
import 'package:jus_mobile_order_app/Providers/navigation_providers.dart';
import 'package:jus_mobile_order_app/Providers/stream_providers.dart';
import 'package:jus_mobile_order_app/Views/home_page_mobile.dart';
import 'package:jus_mobile_order_app/Views/menu_page.dart';
import 'package:jus_mobile_order_app/Views/profile_page.dart';
import 'package:jus_mobile_order_app/Views/review_order_page.dart';
import 'package:jus_mobile_order_app/Views/scan_page.dart';
import 'package:jus_mobile_order_app/Widgets/Dialogs/paused_membership_banner.dart';

class HomeScaffoldMobileApp extends ConsumerWidget {
  const HomeScaffoldMobileApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pageController = ref.watch(bottomNavigationPageControllerProvider);
    final user = ref.watch(currentUserProvider).value ?? const UserModel();
    return Scaffold(
      bottomNavigationBar: const BottomNavBar(),
      body: SafeArea(
        child: Column(
          children: [
            user.subscriptionStatus == SubscriptionStatus.paused
                ? const PausedMembershipBanner()
                : const SizedBox(),
            Flexible(
              child: PageView(
                controller: pageController,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (value) {
                  ref.read(bottomNavigationProvider.notifier).state = value;
                },
                children: [
                  const MobileHomePage(),
                  ScanPage(ref: ref),
                  const MenuPage(),
                  const ReviewOrderPage(),
                  const ProfilePage(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
