import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/utilities.dart';
import 'package:jus_mobile_order_app/Models/user_model.dart';
import 'package:jus_mobile_order_app/Navigation/web_nav_bar_full_screen.dart';
import 'package:jus_mobile_order_app/Navigation/web_nav_bar_small_screen.dart';
import 'package:jus_mobile_order_app/Providers/controller_providers.dart';
import 'package:jus_mobile_order_app/Providers/navigation_providers.dart';
import 'package:jus_mobile_order_app/Providers/stream_providers.dart';
import 'package:jus_mobile_order_app/Views/choose_location_page_web.dart';
import 'package:jus_mobile_order_app/Views/home_page_web.dart';
import 'package:jus_mobile_order_app/Views/menu_page_web.dart';
import 'package:jus_mobile_order_app/constants.dart';

class HomeScaffoldWeb extends ConsumerWidget {
  const HomeScaffoldWeb({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider).value ?? const UserModel();
    final pageController = ref.watch(webNavigationPageControllerProvider);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(AppConstants.screenHeight * 0.1),
        child: Material(
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 18.0),
            child: ResponsiveLayout(
              mobile: WebNavBarSmallScreen(user: user),
              web: WebNavBarFullScreen(user: user),
            ),
          ),
        ),
      ),
      body: PageView(
        controller: pageController,
        physics: const NeverScrollableScrollPhysics(),
        onPageChanged: (value) {
          ref.read(webNavigationProvider.notifier).state = value;
        },
        children: [
          const HomePageWeb(),
          const MenuPageWeb(),
          Container(
            color: Colors.blue,
          ),
          Container(color: Colors.green),
          const ChooseLocationPageWeb(),
        ],
      ),
    );
  }
}
