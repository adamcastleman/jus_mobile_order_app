import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/utilities.dart';

class ProfileIconButton extends ConsumerWidget {
  final double? fontSize;
  final VoidCallback onPressed;
  const ProfileIconButton({this.fontSize, required this.onPressed, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      hoverColor: Colors.transparent,
      onTap: onPressed,
      child: Icon(
        CupertinoIcons.person_alt_circle,
        size: ResponsiveLayout.isMobileBrowser(context) ? 28 : 35,
      ),
    );
  }
}
