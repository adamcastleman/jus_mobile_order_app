import 'package:flutter/material.dart';

class LargeUntappableButton extends StatelessWidget {
  final String buttonText;

  const LargeUntappableButton({required this.buttonText, super.key});
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        minimumSize: MaterialStateProperty.all(
          Size(MediaQuery.of(context).size.width * 0.9, 50.0),
        ),
        backgroundColor: MaterialStateProperty.all(Colors.grey),
      ),
      onPressed: () {},
      child: Text(
        buttonText,
        style: const TextStyle(fontSize: 16),
      ),
    );
  }
}
