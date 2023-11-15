import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OrderHereButton extends StatelessWidget {
  const OrderHereButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () {
        HapticFeedback.lightImpact();
        Navigator.pop(context);
      },
      label: const Padding(
        padding: EdgeInsets.all(8.0),
        child: Text(
          'Order Here',
        ),
      ),
    );
  }
}
