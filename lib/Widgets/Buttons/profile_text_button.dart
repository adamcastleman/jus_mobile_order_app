import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Models/user_model.dart';
import 'package:jus_mobile_order_app/Providers/theme_providers.dart';

class ProfileTextButton extends ConsumerWidget {
  final UserModel user;
  final double? fontSize;
  const ProfileTextButton({required this.user, this.fontSize, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final buttonStyle =
        ref.watch(webNavigationButtonTextStyleProvider(fontSize ?? 18));
    return TextButton(
      child: Text(user.uid == null ? 'login' : 'account', style: buttonStyle),
      onPressed: () {},
    );
  }
}
