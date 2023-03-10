import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MemberIcon extends StatelessWidget {
  final double iconSize;
  const MemberIcon({required this.iconSize, super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4.0),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 0.5),
          borderRadius: BorderRadius.circular(100)),
      child: Icon(
        FontAwesomeIcons.m,
        size: iconSize,
      ),
    );
  }
}
