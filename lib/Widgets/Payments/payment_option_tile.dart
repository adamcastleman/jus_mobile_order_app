import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PaymentOptionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget subtitle;
  final VoidCallback onTap;

  const PaymentOptionTile({
    Key? key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: subtitle,
      trailing: const Icon(
        CupertinoIcons.chevron_right,
        size: 15,
      ),
      onTap: onTap,
    );
  }
}
