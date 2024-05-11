import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/navigation.dart';
import 'package:jus_mobile_order_app/Helpers/spacing_widgets.dart';
import 'package:jus_mobile_order_app/Views/register_page.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/elevated_button_medium.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/info_button.dart';
import 'package:jus_mobile_order_app/constants.dart';

class RewardsGuestCheckout extends ConsumerWidget {
  const RewardsGuestCheckout({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 22.0),
      child: Center(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Earn points. Get free stuff.',
                  style: TextStyle(fontSize: 18),
                ),
                Spacing.horizontal(5),
                InfoButton(
                  onTap: () {
                    HapticFeedback.lightImpact();
                    Navigator.pop(context);
                    NavigationHelpers.navigateToPointsInformationPage(
                      context,
                      ref,
                    );
                  },
                  size: 22,
                ),
              ],
            ),
            Spacing.vertical(20),
            MediumElevatedButton(
              buttonText: 'Join Rewards',
              onPressed: () {
                HapticFeedback.lightImpact();
                NavigationHelpers.navigateToFullScreenSheetOrEndDrawer(context,
                    ref, AppConstants.scaffoldKey, const RegisterPage());
              },
            ),
          ],
        ),
      ),
    );
  }
}
