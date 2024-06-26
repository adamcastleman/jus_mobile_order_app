import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/divider.dart';
import 'package:jus_mobile_order_app/Helpers/enums.dart';
import 'package:jus_mobile_order_app/Helpers/navigation.dart';
import 'package:jus_mobile_order_app/Helpers/spacing_widgets.dart';
import 'package:jus_mobile_order_app/Providers/points_providers.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/info_button.dart';

class WalletSheetHeader extends ConsumerWidget {
  final WalletType walletType;
  const WalletSheetHeader({required this.walletType, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final points = ref.watch(pointsInformationProvider);
    String headerText;

    if (walletType == WalletType.createWallet) {
      headerText = 'Create new Wallet';
    } else if (walletType == WalletType.addFunds) {
      headerText = 'Add Funds to Wallet';
    } else {
      headerText = 'Load Wallet and Pay';
    }
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(
          top: 8.0,
          bottom: 12.0,
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 4.0),
              child: Text(
                headerText,
                style: const TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Earn up to ${points.walletPointsPerDollarMember}x points per \$1',
                    style: const TextStyle(
                      fontSize: 13,
                    ),
                  ),
                  Spacing.horizontal(5),
                  InfoButton(
                    size: 16,
                    onTap: () {
                      HapticFeedback.lightImpact();
                      NavigationHelpers.navigateToPointsInformationPage(
                        context,
                        ref,
                      );
                    },
                  ),
                ],
              ),
            ),
            JusDivider.thin(),
          ],
        ),
      ),
    );
  }
}
