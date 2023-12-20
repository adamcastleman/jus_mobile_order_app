import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/enums.dart';
import 'package:jus_mobile_order_app/Helpers/modal_bottom_sheets.dart';
import 'package:jus_mobile_order_app/Helpers/utilities.dart';
import 'package:jus_mobile_order_app/Providers/payments_providers.dart';
import 'package:jus_mobile_order_app/Providers/stream_providers.dart';
import 'package:jus_mobile_order_app/Sheets/choose_payment_type_sheet.dart';
import 'package:jus_mobile_order_app/Sheets/payments_sheet.dart';
import 'package:jus_mobile_order_app/Widgets/Tiles/add_payment_method_tile.dart';
import 'package:jus_mobile_order_app/Widgets/Tiles/apple_pay_selected_tile.dart';
import 'package:jus_mobile_order_app/Widgets/Tiles/selected_payment_tile.dart';

class PaymentMethodSelector extends ConsumerWidget {
  const PaymentMethodSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider).value!;
    final selectedPayment = ref.watch(selectedPaymentMethodProvider);
    final applePaySelected = ref.watch(applePaySelectedProvider);

    if ((PlatformUtils.isIOS() || PlatformUtils.isMacOS()) &&
        applePaySelected) {
      return const ApplePaySelectedTile();
    } else if (selectedPayment.isEmpty && !applePaySelected) {
      return AddPaymentMethodTile(
          isWallet: false,
          isTransfer: false,
          title: 'Add payment method',
          onTap: () {
            ref.read(pageTypeProvider.notifier).state =
                PageType.selectPaymentMethod;
            _showChoosePaymentTypeSheet(context);
          });
    } else {
      return SelectedPaymentTile(
        onTap: () {
          if (user.uid == null || selectedPayment['isWallet'] == null) {
            _showChoosePaymentTypeSheet(context);
          } else {
            ref.read(pageTypeProvider.notifier).state =
                PageType.selectPaymentMethod;
            _showPaymentSettingsSheet(context);
          }
        },
      );
    }
  }
}

void _showChoosePaymentTypeSheet(BuildContext context) {
  ModalBottomSheet().partScreen(
    isDismissible: true,
    isScrollControlled: true,
    enableDrag: true,
    context: context,
    builder: (context) => const ChoosePaymentTypeSheet(),
  );
}

void _showPaymentSettingsSheet(BuildContext context) {
  ModalBottomSheet().fullScreen(
    context: context,
    builder: (context) => const PaymentSettingsSheet(),
  );
}
