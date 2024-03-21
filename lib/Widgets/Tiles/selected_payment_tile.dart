import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/payment_methods.dart';
import 'package:jus_mobile_order_app/Helpers/pricing.dart';
import 'package:jus_mobile_order_app/Providers/payments_providers.dart';
import 'package:jus_mobile_order_app/Widgets/Icons/chevron_right_icon.dart';

class SelectedPaymentTile extends ConsumerWidget {
  final VoidCallback onTap;
  const SelectedPaymentTile({required this.onTap, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedPayment = ref.watch(selectedPaymentMethodProvider);
    final cardTitle =
        PaymentMethodHelpers().displaySelectedCardText(selectedPayment);

    return ListTile(
      onTap: onTap,
      leading: const Icon(
        CupertinoIcons.creditcard,
      ),
      title: Text(cardTitle),
      subtitle: selectedPayment.isWallet != true
          ? null
          : Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Text(
                'Balance: \$${PricingHelpers.formatAsCurrency((selectedPayment.balance ?? 0) / 100)}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
      trailing: const ChevronRightIcon(),
    );
  }
}
