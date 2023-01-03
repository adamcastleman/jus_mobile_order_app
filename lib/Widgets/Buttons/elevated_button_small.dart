import 'package:flutter/material.dart';

class SmallElevatedButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback onPressed;

  const SmallElevatedButton(
      {required this.buttonText, required this.onPressed, super.key});
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        minimumSize: MaterialStateProperty.all(
          Size(MediaQuery.of(context).size.width * 0.4, 35.0),
        ),
      ),
      onPressed: onPressed,
      child: Text(
        buttonText,
      ),
    );
  }
}
