import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Navigation/bottom_nav_bar.dart';
import 'package:jus_mobile_order_app/Providers/navigation_providers.dart';
import 'package:jus_mobile_order_app/Views/cart_page.dart';
import 'package:jus_mobile_order_app/Views/home_page.dart';
import 'package:jus_mobile_order_app/Views/order_page.dart';
import 'package:jus_mobile_order_app/Views/profile_page.dart';
import 'package:jus_mobile_order_app/Views/scan_page.dart';

class HomeScaffold extends ConsumerWidget {
  const HomeScaffold({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      bottomNavigationBar: const BottomNavBar(),
      body: SafeArea(
        child: IndexedStack(
          index: ref.watch(bottomNavigationProvider),
          children: const [
            HomePage(),
            ScanPage(),
            OrderPage(),
            CartPage(),
            ProfilePage(),
          ],
        ),
      ),
    );
  }
}
