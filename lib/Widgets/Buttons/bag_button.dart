import 'package:flutter/material.dart';
import 'package:jus_mobile_order_app/Helpers/utilities.dart';
import 'package:jus_mobile_order_app/Widgets/Icons/bag_icon.dart';

class BagButton extends StatelessWidget {
  final VoidCallback onPressed;
  const BagButton({required this.onPressed, super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      hoverColor: Colors.transparent,
      onTap: onPressed,
      child: BagIcon(
        iconSize: ResponsiveLayout.isMobileBrowser(context) ? 28 : 35,
      ),
    );
  }
}
