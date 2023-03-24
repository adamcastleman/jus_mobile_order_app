import 'package:flutter/material.dart';
import 'package:jus_mobile_order_app/Helpers/divider.dart';

class CategoryWidget extends StatelessWidget {
  final String text;
  const CategoryWidget({required this.text, Key? key}) : super(key: key);

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
