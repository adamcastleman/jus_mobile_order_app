import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/enums.dart';
import 'package:jus_mobile_order_app/Helpers/modal_sheets.dart';
import 'package:jus_mobile_order_app/Providers/payments_providers.dart';
import 'package:jus_mobile_order_app/Sheets/load_money_and_pay_sheet.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/elevated_button_large.dart';

class OpenLoadMoneyAndPaySheetButton extends ConsumerWidget {
  const OpenLoadMoneyAndPaySheetButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return LargeElevatedButton(
      buttonText: 'Load Money and Pay',
      onPressed: () {
        HapticFeedback.lightImpact();
        ref.read(walletTypeProvider.notifier).state = WalletType.loadAndPay;
        ref.invalidate(selectedLoadAmountIndexProvider);
        ModalBottomSheet().partScreen(
          enableDrag: true,
          isDismissible: true,
          isScrollControlled: true,
          context: context,
          builder: (context) => const LoadWalletAndPaySheet(),
        );
      },
    );
  }
}
