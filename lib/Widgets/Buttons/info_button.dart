import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class InfoButton extends StatelessWidget {
  final VoidCallback onTap;
  final double size;
  final Color color;
  const InfoButton(
      {required this.onTap, required this.size, required this.color, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Icon(
        CupertinoIcons.info_circle_fill,
        size: size,
        color: color,
      ),
    );
  }
}
