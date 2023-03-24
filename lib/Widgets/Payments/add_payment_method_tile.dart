import 'package:flutter/material.dart';
import 'package:jus_mobile_order_app/Widgets/Icons/chevron_right_icon.dart';
import 'package:jus_mobile_order_app/Widgets/Icons/payment_method_icons.dart';

class AddPaymentMethodTile extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  const AddPaymentMethodTile(
      {required this.title, required this.onTap, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: Colors.black,
      leading: const AddPaymentMethodIcon(),
      title: Text(title),
      trailing: const ChevronRightIcon(),
      onTap: onTap,
    );
  }
}
