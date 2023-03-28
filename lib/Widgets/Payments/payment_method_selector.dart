import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/enums.dart';
import 'package:jus_mobile_order_app/Helpers/modal_bottom_sheets.dart';
import 'package:jus_mobile_order_app/Providers/ProviderWidgets/user_provider_widget.dart';
import 'package:jus_mobile_order_app/Providers/payments_providers.dart';
import 'package:jus_mobile_order_app/Widgets/Payments/add_payment_method_tile.dart';
import 'package:jus_mobile_order_app/Widgets/Payments/choose_payment_type_sheet.dart';
import 'package:jus_mobile_order_app/Widgets/Payments/payments_settings_sheet.dart';
import 'package:jus_mobile_order_app/Widgets/Payments/selected_payment_tile.dart';

class PaymentMethodSelector extends ConsumerWidget {
  const PaymentMethodSelector({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedPayment = ref.watch(selectedPaymentMethodProvider);
    return UserProviderWidget(
      builder: (user) => selectedPayment.isEmpty
          ? AddPaymentMethodTile(
              title: 'Add payment method',
              onTap: () => _showChoosePaymentTypeSheet(context),
            )
          : SelectedPaymentTile(
              onTap: () {
                if (user.uid == null) {
                  _showChoosePaymentTypeSheet(context);
                } else {
                  ref.read(pageTypeProvider.notifier).state = PageType.scanPage;
                  _showPaymentSettingsSheet(context);
                }
              },
            ),
    );
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
