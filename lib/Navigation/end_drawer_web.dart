import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/utilities.dart';
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
      width: double.infinity,
      color: Colors.transparent,
      child: Row(
        children: [
          const Expanded(
            child: SizedBox(),
          ),
          Container(
            color: backgroundColor,
            height: MediaQuery.of(context).size.height,
            width: ResponsiveLayout.isWeb(context)
                ? 430
                : ResponsiveLayout.isMobileBrowser(context)
                    ? MediaQuery.of(context).size.width
                    : double.infinity,
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
          ),
        ],
      ),
    );
  }
}
