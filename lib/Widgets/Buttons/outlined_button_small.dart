import 'package:flutter/material.dart';

class SmallOutlineButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback onPressed;
  const SmallOutlineButton(
      {required this.buttonText, required this.onPressed, super.key});
  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        minimumSize: MaterialStateProperty.all(
          Size(MediaQuery.of(context).size.width * 0.4, 35.0),
        ),
      ),
      child: Text(buttonText),
    );
  }
}
