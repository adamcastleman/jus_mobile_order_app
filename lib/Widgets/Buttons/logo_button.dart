import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Providers/controller_providers.dart';
import 'package:jus_mobile_order_app/Providers/navigation_providers.dart';

class LogoButton extends ConsumerWidget {
  const LogoButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      hoverColor: Colors.transparent,
      splashColor: Colors.transparent,
      child: Image.asset('assets/jus_logo_splash.png', scale: 6),
      onTap: () {
        ref.read(webNavigationProvider.notifier).state = 0;
        ref.read(webNavigationPageControllerProvider).jumpToPage(0);
      },
    );
  }
}
