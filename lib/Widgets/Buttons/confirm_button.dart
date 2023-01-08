import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ConfirmButton extends StatelessWidget {
  const ConfirmButton({super.key});
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(CupertinoIcons.check_mark_circled),
      iconSize: 22,
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }
}
