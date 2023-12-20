import 'package:flutter/material.dart';
import 'package:jus_mobile_order_app/Widgets/Icons/payment_method_icons.dart';

class NoChargePaymentTile extends StatelessWidget {
  const NoChargePaymentTile({super.key});

  @override
  Widget build(BuildContext context) {
    return const ListTile(
      leading: PaymentMethodIcon(),
      title: Text('No charge - continue to checkout'),
    );
  }
}
