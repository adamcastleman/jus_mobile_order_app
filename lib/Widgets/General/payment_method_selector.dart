import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/enums.dart';
import 'package:jus_mobile_order_app/Helpers/payment_methods.dart';
import 'package:jus_mobile_order_app/Helpers/utilities.dart';
import 'package:jus_mobile_order_app/Providers/loading_providers.dart';
import 'package:jus_mobile_order_app/Providers/payments_providers.dart';
import 'package:jus_mobile_order_app/Providers/stream_providers.dart';
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
    final tileKey = UniqueKey();
    final cardId = selectedPayment.cardId ?? selectedPayment.gan;

    if (PlatformUtils.isIOS() && applePaySelected) {
      return const ApplePaySelectedTile();
    } else if (cardId == null && !applePaySelected) {
      return AddPaymentMethodTile(
          tileKey: tileKey,
          isWallet: false,
          isTransfer: false,
          title: 'Add payment method',
          onTap: () {
            ref.read(pageTypeProvider.notifier).state =
                PageType.selectPaymentMethod;
            ref.read(tileKeyProvider.notifier).state = tileKey;
            PaymentMethodHelpers().showAddCardOrWallet(context);
          });
    } else {
      return SelectedPaymentTile(
        onTap: () {
          HapticFeedback.lightImpact();
          if (user.uid == null || cardId == null) {
            PaymentMethodHelpers().showAddCardOrWallet(context);
          } else {
            ref.read(pageTypeProvider.notifier).state =
                PageType.selectPaymentMethod;

            PaymentMethodHelpers().showPaymentMethodSheet(context);
          }
        },
      );
    }
  }
}
