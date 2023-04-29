import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/spacing_widgets.dart';
import 'package:jus_mobile_order_app/Providers/theme_providers.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/close_button.dart';
import 'package:jus_mobile_order_app/Widgets/Lists/transaction_history_list_view.dart';

class TransactionHistorySheet extends ConsumerWidget {
  const TransactionHistorySheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final backgroundColor = ref.watch(backgroundColorProvider);
    return Container(
      color: backgroundColor,
      child: Padding(
        padding: const EdgeInsets.only(
            top: 50.0, left: 12.0, right: 12.0, bottom: 12.0),
        child: ListView(
          primary: false,
          children: [
            const Align(
              alignment: Alignment.topRight,
              child: JusCloseButton(
                removePadding: true,
              ),
            ),
            Text(
              'Transaction History',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            Spacing().vertical(15),
            const TransactionHistoryListView(),
            Spacing().vertical(5),
            const Center(
              child: Text(
                'That\'s all (from the last 120 days)',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
