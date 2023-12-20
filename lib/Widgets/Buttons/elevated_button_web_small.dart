import 'package:flutter/material.dart';

class SmallElevatedButtonWeb extends StatelessWidget {
  final String buttonText;
  final VoidCallback onPressed;
  final double buttonHeight;
  final double buttonWidth;
  final bool isHovering = false; // You'll need to manage this state

  const SmallElevatedButtonWeb(
      {required this.buttonText,
      required this.buttonHeight,
      required this.buttonWidth,
      required this.onPressed,
      super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
          if (states.contains(MaterialState.hovered)) {
            return Colors.black.withOpacity(0.7); // 70% opacity on hover
          }
          return Colors.black; // Default color
        }),
        minimumSize: MaterialStateProperty.all(
          Size(buttonHeight, buttonWidth),
        ),
        // Other styles...
      ),
      onPressed: onPressed,
      child: Text(
        buttonText,
        style: const TextStyle(fontSize: 18),
      ),
    );
  }
}
