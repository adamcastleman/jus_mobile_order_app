import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/divider.dart';
import 'package:jus_mobile_order_app/Models/payments_model.dart';
import 'package:jus_mobile_order_app/Payments/saved_payment_tile.dart';

class SavedPaymentsListView extends ConsumerWidget {
  final List<PaymentsModel> cards;
  const SavedPaymentsListView({required this.cards, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView.separated(
      shrinkWrap: true,
      primary: false,
      itemCount: cards.isEmpty ? 0 : cards.length,
      separatorBuilder: (context, index) => JusDivider().thin(),
      itemBuilder: (context, index) => SavedPaymentTile(card: cards[index]),
    );
  }
}
