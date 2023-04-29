import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/enums.dart';
import 'package:jus_mobile_order_app/Helpers/modal_bottom_sheets.dart';
import 'package:jus_mobile_order_app/Payments/add_payment_method_tile.dart';
import 'package:jus_mobile_order_app/Payments/apple_pay_selected_tile.dart';
import 'package:jus_mobile_order_app/Payments/choose_payment_type_sheet.dart';
import 'package:jus_mobile_order_app/Payments/payments_sheet.dart';
import 'package:jus_mobile_order_app/Payments/selected_payment_tile.dart';
import 'package:jus_mobile_order_app/Providers/ProviderWidgets/user_provider_widget.dart';
import 'package:jus_mobile_order_app/Providers/payments_providers.dart';

class PaymentMethodSelector extends ConsumerWidget {
  const PaymentMethodSelector({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedPayment = ref.watch(selectedPaymentMethodProvider);
    final applePaySelected = ref.watch(applePaySelectedProvider);
    return UserProviderWidget(
      builder: (user) {
        if ((Platform.isIOS || Platform.isMacOS) && applePaySelected) {
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
      },
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
