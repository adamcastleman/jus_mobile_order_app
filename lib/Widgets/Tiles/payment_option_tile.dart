import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PaymentOptionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget? subtitle;
  final Widget? trailing;
  final VoidCallback onTap;

  const PaymentOptionTile({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.trailing,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: subtitle,
      trailing: trailing != null
          ? SizedBox(
              width: 24,
              child: trailing,
            )
          : const Icon(
              CupertinoIcons.chevron_right,
              size: 15,
            ),
      onTap: onTap,
    );
  }
}
