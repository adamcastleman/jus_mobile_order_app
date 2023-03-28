import 'package:flutter/material.dart';

class LargeElevatedButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String? buttonText;

  const LargeElevatedButton({
    this.buttonText,
    required this.onPressed,
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        minimumSize: MaterialStateProperty.all(
          Size(MediaQuery.of(context).size.width * 0.9, 50.0),
        ),
      ),
      onPressed: onPressed,
      child: Text(
        buttonText ?? '',
        style: const TextStyle(fontSize: 16),
      ),
    );
  }
}
