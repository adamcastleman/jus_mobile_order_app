import 'package:flutter/material.dart';
import 'package:jus_mobile_order_app/Widgets/Helpers/divider.dart';

class CartCategory extends StatelessWidget {
  final String text;
  const CartCategory({required this.text, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          text,
          style: const TextStyle(fontSize: 16),
        ),
        JusDivider().thick(),
      ],
    );
  }
}
