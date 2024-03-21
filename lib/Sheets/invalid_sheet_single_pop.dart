import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Providers/loading_providers.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/elevated_button_large.dart';

class InvalidSheetSinglePop extends ConsumerWidget {
  final String error;
  const InvalidSheetSinglePop({required this.error, super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 22.0),
      height: MediaQuery.of(context).size.height * 0.33,
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              'Whoops...',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            AutoSizeText(
              error,
              style: Theme.of(context).textTheme.titleMedium,
              maxLines: 3,
            ),
            Center(
              child: LargeElevatedButton(
                buttonText: 'Close',
                onPressed: () {
                  ref.read(loadingProvider.notifier).state = false;
                  ref.invalidate(applePayLoadingProvider);
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
