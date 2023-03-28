import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class JusCloseButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final double? iconSize;
  final bool? removePadding;
  const JusCloseButton(
      {this.onPressed, this.iconSize, this.removePadding, super.key});
  @override
  Widget build(BuildContext context) {
    return IconButton(
        constraints: removePadding == true ? const BoxConstraints() : null,
        icon: const Icon(CupertinoIcons.clear_circled),
        iconSize: iconSize ?? 25,
        onPressed: onPressed ??
            () {
              HapticFeedback.lightImpact();
              Navigator.pop(context);
            });
  }
}
