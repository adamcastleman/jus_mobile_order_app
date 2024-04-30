import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/divider.dart';
import 'package:jus_mobile_order_app/Helpers/loading.dart';
import 'package:jus_mobile_order_app/Helpers/spacing_widgets.dart';
import 'package:jus_mobile_order_app/Helpers/utilities.dart';
import 'package:jus_mobile_order_app/Providers/ProviderWidgets/subscription_data_provider_widget.dart';
import 'package:jus_mobile_order_app/Providers/membership_providers.dart';
import 'package:jus_mobile_order_app/Services/subscription_services.dart';
import 'package:jus_mobile_order_app/Widgets/General/sheet_notch.dart';

class CancelMembershipConfirmationSheet extends StatelessWidget {
  final WidgetRef ref;
  const CancelMembershipConfirmationSheet({required this.ref, super.key});

  @override
  Widget build(BuildContext context) {
    return SubscriptionDataProviderWidget(
      builder: (subscription) => Padding(
        padding: EdgeInsets.only(
            top: PlatformUtils.isWeb() ? 28.0 : 0.0, left: 12.0, right: 12.0),
        child: Wrap(
          children: [
            PlatformUtils.isWeb() ? const SizedBox() : const SheetNotch(),
            Spacing.vertical(35),
            Center(
              child: Text(
                'Cancel Membership?',
                style: const TextStyle(fontSize: 23),
                textAlign:
                    PlatformUtils.isWeb() ? TextAlign.center : TextAlign.left,
              ),
            ),
            Spacing.vertical(
              60,
            ),
            Text(
              'You\'ve saved \$${(subscription.totalSaved! / 100).toStringAsFixed(2)}, and earned an extra ${subscription.bonusPoints} bonus points since you\'ve joined.',
              style: const TextStyle(fontSize: 16),
              textAlign:
                  PlatformUtils.isWeb() ? TextAlign.center : TextAlign.left,
            ),
            Spacing.vertical(
              60,
            ),
            JusDivider.thin(),
            Column(
              children: [
                ListTile(
                  title: Text(
                    'No, I\'d like to remain a member',
                    textAlign: PlatformUtils.isWeb()
                        ? TextAlign.center
                        : TextAlign.left,
                  ),
                  trailing: ref.watch(updateMembershipLoadingProvider) == true
                      ? const SizedBox(
                          height: 50,
                          width: 50,
                          child: Loading(),
                        )
                      : const SizedBox(),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                JusDivider.thin(),
                ListTile(
                  title: Text(
                    'Yes, I\'d like to cancel',
                    style: const TextStyle(color: Colors.red),
                    textAlign: PlatformUtils.isWeb()
                        ? TextAlign.center
                        : TextAlign.left,
                  ),
                  onTap: () async {
                    ref.read(updateMembershipLoadingProvider.notifier).state =
                        true;
                    Navigator.pop(context);
                    await SubscriptionServices()
                        .cancelSquareSubscriptionCloudFunction();
                    ref.invalidate(updateMembershipLoadingProvider);
                  },
                ),
              ],
            ),
            Spacing.vertical(
              160,
            ),
          ],
        ),
      ),
    );
  }
}
