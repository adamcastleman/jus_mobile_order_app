import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/navigation.dart';
import 'package:jus_mobile_order_app/Providers/navigation_providers.dart';

class WebHamburgerMenuButton extends StatelessWidget {
  final WidgetRef ref;
  final GlobalKey<ScaffoldState> scaffoldKey;
  const WebHamburgerMenuButton(
      {required this.ref, required this.scaffoldKey, super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      hoverColor: Colors.transparent,
      child: const Icon(
        CupertinoIcons.line_horizontal_3,
        size: 26,
      ),
      onTap: () {
        ref.read(isInHamburgerMenuProvider.notifier).state = true;
        NavigationHelpers.navigateToHamburgerMenu(ref, scaffoldKey);
      },
    );
  }
}
