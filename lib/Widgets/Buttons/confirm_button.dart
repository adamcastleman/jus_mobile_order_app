import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ConfirmButton extends StatelessWidget {
  final VoidCallback? onPressed;
  const ConfirmButton({this.onPressed, super.key});
  @override
  Widget build(BuildContext context) {
    return IconButton(
        icon: const Icon(CupertinoIcons.check_mark_circled),
        iconSize: 25,
        onPressed: onPressed ??
            () {
              Navigator.pop(context);
            });
  }
}
