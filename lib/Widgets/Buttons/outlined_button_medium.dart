import 'package:flutter/material.dart';

class MediumOutlineButton extends StatelessWidget {
  final String buttonText;
  final Color? buttonColor;
  final VoidCallback onPressed;
  const MediumOutlineButton(
      {required this.buttonText,
      this.buttonColor,
      required this.onPressed,
      super.key});
  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(buttonColor ?? Colors.white),
        minimumSize: MaterialStateProperty.all(
          Size(MediaQuery.of(context).size.width * 0.4, 45.0),
        ),
      ),
      child: Text(buttonText),
    );
  }
}
