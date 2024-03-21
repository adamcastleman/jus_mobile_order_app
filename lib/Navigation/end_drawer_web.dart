import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Providers/navigation_providers.dart';
import 'package:jus_mobile_order_app/Providers/order_providers.dart';
import 'package:jus_mobile_order_app/Providers/theme_providers.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/close_button.dart';

class EndDrawerWeb extends ConsumerWidget {
  final Widget child;
  const EndDrawerWeb({required this.child, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final backgroundColor = ref.watch(backgroundColorProvider);
    // The checkout page invalidates a lot of providers when a user exits,
    // therefore, we need to handle the close event in that class
    // directly. We hide this generic close button in this case.
    final isCheckoutPage = ref.watch(isCheckOutPageProvider);
    return Container(
      height: double.infinity,
      width: 500,
      color: backgroundColor,
      child: Stack(
        children: [
          child,
          isCheckoutPage
              ? const SizedBox()
              : Positioned(
                  top: 0,
                  right: 0,
                  child: JusCloseButton(
                    onPressed: () {
                      ref.read(isInHamburgerMenuProvider.notifier).state =
                          false;
                      Navigator.pop(context);
                    },
                  ),
                )
        ],
      ),
    );
  }
}
