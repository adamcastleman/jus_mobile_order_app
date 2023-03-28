import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/payments.dart';
import 'package:jus_mobile_order_app/Providers/payments_providers.dart';
import 'package:jus_mobile_order_app/Widgets/Icons/chevron_right_icon.dart';

class SelectedPaymentTile extends ConsumerWidget {
  final VoidCallback onTap;
  const SelectedPaymentTile({required this.onTap, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedPayment = ref.watch(selectedPaymentMethodProvider);
    final cardTitle =
        PaymentsHelper().displaySelectedCardTextFromMap(selectedPayment);

    return ListTile(
      leading: const Icon(
        CupertinoIcons.creditcard,
      ),
      title: Text(cardTitle),
      trailing: const ChevronRightIcon(),
      onTap: onTap,
    );
  }
}
