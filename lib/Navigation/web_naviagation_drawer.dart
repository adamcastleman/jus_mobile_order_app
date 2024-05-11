import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/navigation.dart';
import 'package:jus_mobile_order_app/Helpers/scan.dart';
import 'package:jus_mobile_order_app/Helpers/spacing_widgets.dart';
import 'package:jus_mobile_order_app/Models/user_model.dart';
import 'package:jus_mobile_order_app/Providers/stream_providers.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/cleanse_text_button.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/locations_text_button.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/membership_text_button.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/menu_text_button.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/profile_text_button.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/rewards_text_button.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/scan_text_button.dart';
import 'package:jus_mobile_order_app/constants.dart';

class WebNavigationDrawer extends StatelessWidget {
  final WidgetRef ref;
  const WebNavigationDrawer({required this.ref, super.key});

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider).value ?? const UserModel();
    return Container(
      color: Colors.white,
      height: AppConstants.screenHeight,
      width: AppConstants.screenWidth,
      child: Padding(
        padding: const EdgeInsets.only(left: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Spacing.vertical(40),
            const MenuTextButton(fontSize: 24),
            Spacing.vertical(20),
            const CleanseTextButton(fontSize: 24),
            Spacing.vertical(20),
            user.uid != null && user.uid!.isNotEmpty
                ? ScanTextButton(ref: ref, fontSize: 24)
                : const RewardsTextButton(fontSize: 24),
            Spacing.vertical(20),
            const MembershipTextButton(fontSize: 24),
            Spacing.vertical(20),
            LocationsTextButton(
              fontSize: 24,
              onPressed: () {
                ScanHelpers.cancelQrTimer(ref);
                NavigationHelpers().navigateToLocationPage(context, ref);
              },
            ),
            Spacing.vertical(20),
            const ProfileTextButton(),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
