import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/navigation.dart';
import 'package:jus_mobile_order_app/Helpers/scan.dart';
import 'package:jus_mobile_order_app/Models/user_model.dart';
import 'package:jus_mobile_order_app/Providers/navigation_providers.dart';
import 'package:jus_mobile_order_app/Providers/stream_providers.dart';
import 'package:jus_mobile_order_app/Providers/theme_providers.dart';
import 'package:jus_mobile_order_app/constants.dart';

class MembershipTextButton extends ConsumerWidget {
  final double? fontSize;
  const MembershipTextButton({this.fontSize, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider).value ?? const UserModel();
    final isDrawerOpen = AppConstants.scaffoldKey.currentState?.isEndDrawerOpen;
    final buttonStyle = ref.watch(
      webNavigationButtonTextStyleProvider(
        fontSize ?? 18,
      ),
    );
    return TextButton(
      child: Text('membership', style: buttonStyle),
      onPressed: () {
        ScanHelpers.cancelQrTimer(ref);
        NavigationHelpers.handleMembershipNavigation(
          context,
          ref,
          user,
        );
        isDrawerOpen ?? Navigator.pop(context);
        ref.invalidate(isInHamburgerMenuProvider);
      },
    );
  }
}
