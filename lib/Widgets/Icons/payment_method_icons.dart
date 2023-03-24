import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddPaymentMethodIcon extends StatelessWidget {
  const AddPaymentMethodIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Icon(
      CupertinoIcons.creditcard_fill,
      color: Colors.black,
    );
  }
}

class PaymentMethodIcon extends StatelessWidget {
  const PaymentMethodIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Icon(
      CupertinoIcons.creditcard,
    );
  }
}
