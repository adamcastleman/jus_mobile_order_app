import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddPaymentMethodIcon extends StatelessWidget {
  const AddPaymentMethodIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return const Icon(
      CupertinoIcons.creditcard_fill,
      color: Colors.black,
    );
  }
}

class PaymentMethodIcon extends StatelessWidget {
  const PaymentMethodIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return const Icon(
      CupertinoIcons.creditcard,
    );
  }
}
