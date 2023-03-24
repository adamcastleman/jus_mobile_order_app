import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class DefaultPaymentCheckbox extends StatelessWidget {
  final bool value;
  final Function(bool?) onChanged;

  const DefaultPaymentCheckbox({
    required this.value,
    required this.onChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      title: const AutoSizeText(
        'Set as default payment method',
        maxLines: 1,
      ),
      activeColor: Colors.black,
      value: value,
      onChanged: onChanged,
    );
  }
}
