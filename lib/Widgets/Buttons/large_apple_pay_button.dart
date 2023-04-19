import 'package:flutter/material.dart';
import 'package:pay/pay.dart';

class LargeApplePayButton extends StatelessWidget {
  final VoidCallback onPressed;
  const LargeApplePayButton({
    required this.onPressed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 45,
      width: MediaQuery.of(context).size.width * 0.9,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(50),
        child: RawApplePayButton(
          onPressed: onPressed,
          type: ApplePayButtonType.inStore,
        ),
      ),
    );
  }
}
