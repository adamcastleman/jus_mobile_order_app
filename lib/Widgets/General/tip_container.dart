import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Providers/order_providers.dart';
import 'package:jus_mobile_order_app/Providers/theme_providers.dart';

class TipContainer extends ConsumerWidget {
  const TipContainer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 12.0,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Colors.black, width: 0.5),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: AutoSizeText(
              'Would you like to thank those who served you with a tip?',
              style: TextStyle(fontSize: 20),
              maxLines: 2,
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: _buildTipOptions(ref),
          ),
        ],
      ),
    );
  }

  Widget _buildTipOptions(WidgetRef ref) {
    final tipPercentages = [0, 10, 15, 20];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: tipPercentages
          .map((percent) => _tipAmountButton(ref, percent))
          .toList(),
    );
  }

  Widget _tipAmountButton(WidgetRef ref, int percent) {
    final isSelected = ref.watch(selectedTipIndexProvider) == percent;
    final backgroundColor =
        isSelected ? ref.watch(selectedCardColorProvider) : Colors.white;
    final borderColor = ref.watch(selectedCardBorderColorProvider);

    return InkWell(
      onTap: () => _onTipSelected(ref, percent),
      child: Container(
        height: 75,
        width: 75,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(color: borderColor, width: 0.5),
        ),
        child: Center(
          child: Text(
            percent == 0 ? 'No' : '$percent%',
            style: const TextStyle(fontSize: 18),
          ),
        ),
      ),
    );
  }

  void _onTipSelected(WidgetRef ref, int percent) {
    HapticFeedback.lightImpact();
    ref.read(selectedTipIndexProvider.notifier).state = percent;
    ref.read(selectedTipPercentageProvider.notifier).state = percent;
  }
}
