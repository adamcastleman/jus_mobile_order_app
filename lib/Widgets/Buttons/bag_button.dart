import 'package:flutter/material.dart';
import 'package:jus_mobile_order_app/Widgets/Icons/bag_icon.dart';

class BagButton extends StatelessWidget {
  const BagButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      hoverColor: Colors.transparent,
      icon: const BagIcon(),
      iconSize: 22,
      onPressed: () {},
    );
  }
}
