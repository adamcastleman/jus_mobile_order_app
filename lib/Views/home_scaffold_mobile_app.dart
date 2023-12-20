import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Navigation/bottom_nav_bar.dart';
import 'package:jus_mobile_order_app/Providers/controller_providers.dart';
import 'package:jus_mobile_order_app/Providers/navigation_providers.dart';
import 'package:jus_mobile_order_app/Views/home_page_mobile.dart';
import 'package:jus_mobile_order_app/Views/menu_page_mobile.dart';
import 'package:jus_mobile_order_app/Views/profile_page.dart';
import 'package:jus_mobile_order_app/Views/review_order_page.dart';
import 'package:jus_mobile_order_app/Views/scan_page.dart';

class HomeScaffoldMobileApp extends ConsumerWidget {
  const HomeScaffoldMobileApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pageController = ref.watch(bottomNavigationPageControllerProvider);
    return Scaffold(
      bottomNavigationBar: const BottomNavBar(),
      body: SafeArea(
        child: PageView(
          controller: pageController,
          physics: const NeverScrollableScrollPhysics(),
          onPageChanged: (value) {
            ref.read(bottomNavigationProvider.notifier).state = value;
          },
          children: const [
            MobileHomePage(),
            ScanPage(),
            MenuPageMobile(),
            ReviewOrderPage(),
            ProfilePage(),
          ],
        ),
      ),
    );
  }
}
