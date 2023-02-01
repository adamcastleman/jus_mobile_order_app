import 'package:flutter/material.dart';

class MediumUntappableButton extends StatelessWidget {
  final String buttonText;

  const MediumUntappableButton({required this.buttonText, super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        minimumSize: MaterialStateProperty.all(
          Size(MediaQuery.of(context).size.width * 0.4, 45.0),
        ),
        backgroundColor: MaterialStateProperty.all(Colors.grey),
      ),
      onPressed: () {},
      child: Text(
        buttonText,
      ),
    );
  }
}
