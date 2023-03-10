import 'package:flutter/material.dart';
import 'package:jus_mobile_order_app/Models/payments_model.dart';

class CreditCardName extends StatelessWidget {
  final List<PaymentsModel> paymentMethods;
  final int index;
  const CreditCardName(
      {required this.paymentMethods, required this.index, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final card = paymentMethods[index];
    final cardNickname = card.cardNickname;
    final brand = card.brand.toString();
    if (brand == 'squareGiftCard') {
      return Text(
        '$cardNickname ending in ${card.lastFourDigits}',
        style: const TextStyle(fontSize: 15),
      );
    } else {
      return Text(
        '$cardNickname - ${card.brand[0].toUpperCase()}${card.brand.substring(1)} ending in ${card.lastFourDigits}',
        style: const TextStyle(fontSize: 15),
      );
    }
  }
}
