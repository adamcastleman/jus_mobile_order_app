import 'package:flutter/material.dart';

class UsePointsButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback onPressed;

  const UsePointsButton(
      {required this.buttonText, required this.onPressed, super.key});
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        minimumSize: MaterialStateProperty.all(
          Size(MediaQuery.of(context).size.width * 0.2, 35.0),
        ),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
        ),
      ),
      onPressed: onPressed,
      child: Text(
        buttonText,
      ),
    );
  }
}
