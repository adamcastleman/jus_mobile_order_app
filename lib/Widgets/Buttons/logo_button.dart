import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/navigation.dart';
import 'package:jus_mobile_order_app/Helpers/scan.dart';

class LogoButton extends ConsumerWidget {
  const LogoButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      hoverColor: Colors.transparent,
      splashColor: Colors.transparent,
      child: Image.asset('assets/jus_logo_splash.png'),
      onTap: () {
        ScanHelpers.cancelQrTimer(ref);
        NavigationHelpers.navigateToHomePageWeb(ref);
      },
    );
  }
}
