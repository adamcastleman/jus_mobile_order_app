import 'package:flutter/material.dart';

class LargeOutlineButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback onPressed;
  final Color? color;
  const LargeOutlineButton(
      {required this.buttonText,
      required this.onPressed,
      this.color,
      super.key});
  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: ButtonStyle(
        minimumSize: MaterialStateProperty.all(
          Size(MediaQuery.of(context).size.width * 0.9, 50.0),
        ),
        backgroundColor: color == null
            ? MaterialStateProperty.all(Colors.white)
            : MaterialStateProperty.all(color),
      ),
      onPressed: onPressed,
      child: Text(
        buttonText,
        style: const TextStyle(fontSize: 16),
      ),
    );
  }
}
