import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Providers/loading_providers.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/elevated_button_large_loading.dart';
import 'package:pay/pay.dart';

class LargeApplePayButton extends ConsumerWidget {
  final VoidCallback onPressed;
  const LargeApplePayButton({
    required this.onPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loading = ref.watch(applePayLoadingProvider);
    if (loading == true) {
      return const LargeElevatedLoadingButton();
    }
    return SizedBox(
      height: 45,
      width: MediaQuery.of(context).size.width * 0.9,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(50),
        child: RawApplePayButton(
          onPressed: onPressed,
          type: ApplePayButtonType.inStore,
        ),
      ),
    );
  }
}
