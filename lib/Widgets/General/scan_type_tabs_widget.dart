import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/spacing_widgets.dart';
import 'package:jus_mobile_order_app/Providers/scan_providers.dart';

class ScanTypeTabsWidget extends ConsumerWidget {
  const ScanTypeTabsWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoryIndex = ref.watch(scanCategoryProvider);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: Column(
            children: [
              TextButton(
                child: const Text(
                  'Scan and pay',
                  style: TextStyle(fontSize: 17),
                ),
                onPressed: () {
                  ref.read(scanCategoryProvider.notifier).state = 0;
                },
              ),
              Spacing.vertical(5),
              Container(
                height: 0.5,
                color: categoryIndex == 0 ? Colors.black : Colors.transparent,
              ),
            ],
          ),
        ),
        Expanded(
          child: Column(
            children: [
              TextButton(
                child: const Text(
                  'Scan only',
                  style: TextStyle(fontSize: 17),
                ),
                onPressed: () {
                  ref.read(scanCategoryProvider.notifier).state = 1;
                },
              ),
              Container(
                height: 0.5,
                color: categoryIndex == 1 ? Colors.black : Colors.transparent,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
