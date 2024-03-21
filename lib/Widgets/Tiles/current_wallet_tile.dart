import 'package:flutter/material.dart';
import 'package:jus_mobile_order_app/Helpers/pricing.dart';
import 'package:jus_mobile_order_app/Models/payments_model.dart';

class CurrentWalletTile extends StatelessWidget {
  final PaymentsModel wallet;
  const CurrentWalletTile({required this.wallet, super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        '${wallet.cardNickname} x${wallet.last4}',
      ),
      subtitle: Text(
        'Balance: \$${PricingHelpers.formatAsCurrency((wallet.balance ?? 0) / 100)}',
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }
}
