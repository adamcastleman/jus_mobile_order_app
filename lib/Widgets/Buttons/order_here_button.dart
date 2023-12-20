import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/utilities.dart';
import 'package:jus_mobile_order_app/Providers/controller_providers.dart';
import 'package:jus_mobile_order_app/Providers/navigation_providers.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/outlined_button_small.dart';

class OrderHereButton extends ConsumerWidget {
  const OrderHereButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SmallOutlineButton(
        buttonText: 'Order Here',
        onPressed: () {
          HapticFeedback.lightImpact();
          if (PlatformUtils.isIOS() || PlatformUtils.isAndroid()) {
            Navigator.pop(context);
          } else {
            ref.read(webNavigationProvider.notifier).state = 1;
            ref.read(webNavigationPageControllerProvider).jumpToPage(1);
          }
        });
  }
}
