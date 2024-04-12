import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/navigation.dart';
import 'package:jus_mobile_order_app/Helpers/scan.dart';
import 'package:jus_mobile_order_app/Helpers/utilities.dart';
import 'package:jus_mobile_order_app/Providers/navigation_providers.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/bag_button.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/cleanse_text_button.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/locations_text_button.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/logo_button.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/membership_text_button.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/menu_text_button.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/profile_icon_button.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/rewards_text_button.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/web_hamburger_menu_button.dart';

class WebNavBar extends StatelessWidget {
  final WidgetRef ref;
  final GlobalKey<ScaffoldState> scaffoldKey;

  const WebNavBar({required this.ref, required this.scaffoldKey, super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobileBrowser: _mobileLayout(context, ref),
      tablet: _mobileLayout(context, ref),
      web: _webLayout(context, ref),
    );
  }

  _mobileLayout(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(left: 30.0, right: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(
            width: 50,
            height: 50,
            child: LogoButton(),
          ),
          SizedBox(
            width: 125,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 2.0),
                  child: BagButton(
                    onPressed: () {
                      ScanHelpers.cancelQrTimer(ref);
                      NavigationHelpers.navigateToBagPage(ref, scaffoldKey);
                    },
                  ),
                ),
                ProfileIconButton(
                  onPressed: () {
                    ScanHelpers.cancelQrTimer(ref);
                    NavigationHelpers.navigateToProfilePage(ref, scaffoldKey);
                  },
                ),
                WebHamburgerMenuButton(ref: ref, scaffoldKey: scaffoldKey),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _webLayout(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildLogoAndButtons(context, ref),
        _buildRightSideButtons(context, ref),
      ],
    );
  }

  Row _buildLogoAndButtons(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 40.0),
          child: SizedBox(
            height: 55,
            width: 55,
            child: LogoButton(),
          ),
        ),
        Row(
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: MenuTextButton(),
            ),
            const Padding(
              padding: EdgeInsets.all(10.0),
              child: CleanseTextButton(),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              child: RewardsTextButton(),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              child: MembershipTextButton(),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: LocationsTextButton(
                onPressed: () {
                  ScanHelpers.cancelQrTimer(ref);
                  NavigationHelpers().navigateToLocationPage(context, ref);
                  if (ResponsiveLayout.isMobileBrowser(context) ||
                      ResponsiveLayout.isTablet(context)) {
                    NavigationHelpers.popEndDrawer(context);
                    ref.invalidate(isInHamburgerMenuProvider);
                  }
                },
              ),
            )
          ],
        ),
      ],
    );
  }

  Widget _buildRightSideButtons(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(right: 30.0),
      child: SizedBox(
        width: 100,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 4.0),
              child: BagButton(
                onPressed: () {
                  ScanHelpers.cancelQrTimer(ref);
                  NavigationHelpers.navigateToBagPage(ref, scaffoldKey);
                },
              ),
            ),
            ProfileIconButton(
              onPressed: () {
                ScanHelpers.cancelQrTimer(ref);
                NavigationHelpers.navigateToProfilePage(ref, scaffoldKey);
              },
            ),
          ],
        ),
      ),
    );
  }
}
