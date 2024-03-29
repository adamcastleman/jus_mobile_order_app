import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Providers/payments_providers.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/confirm_button.dart';
import 'package:jus_mobile_order_app/constants.dart';

class SelectWalletLoadAmountSheet extends ConsumerWidget {
  const SelectWalletLoadAmountSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loadAmounts = ref.watch(walletLoadAmountsProvider);
    final loadAmountsIndex = ref.watch(selectedLoadAmountIndexProvider);
    FixedExtentScrollController scrollController = FixedExtentScrollController(
      initialItem:
          loadAmountsIndex ?? AppConstants.defaultWalletLoadAmountIndex,
    );

    return SizedBox(
      height: 300,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Select amount',
                  style: TextStyle(fontSize: 22),
                ),
                ConfirmButton(),
              ],
            ),
            Expanded(
              child: CupertinoPicker(
                scrollController: scrollController,
                itemExtent: 50,
                onSelectedItemChanged: (value) {
                  ref.read(selectedLoadAmountIndexProvider.notifier).state =
                      value;
                  ref.read(selectedLoadAmountProvider.notifier).state =
                      loadAmounts[value];
                },
                children: List.generate(
                  loadAmounts.length,
                  (index) => Center(
                    child: Text(
                      '\$${(loadAmounts[index] / 100).toStringAsFixed(2)}',
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
