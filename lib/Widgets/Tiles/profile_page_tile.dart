import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/divider.dart';
import 'package:jus_mobile_order_app/Providers/ProviderWidgets/user_provider_widget.dart';

class ProfilePageTile extends ConsumerWidget {
  final Widget icon;
  final String title;
  final VoidCallback onTap;
  final bool? isLastTile;
  const ProfilePageTile(
      {required this.icon,
      required this.title,
      required this.onTap,
      this.isLastTile,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return UserProviderWidget(
      builder: (user) => Column(
        children: [
          ListTile(
            leading: icon,
            title: Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            onTap: onTap,
          ),
          isLastTile == null || isLastTile != true
              ? JusDivider().thin()
              : JusDivider().thick(),
        ],
      ),
    );
  }
}
