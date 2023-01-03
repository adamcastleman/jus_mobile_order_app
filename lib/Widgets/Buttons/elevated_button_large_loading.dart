import 'package:flutter/material.dart';

class LargeElevatedLoadingButton extends StatelessWidget {
  const LargeElevatedLoadingButton({super.key});
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        minimumSize: MaterialStateProperty.all(
          Size(MediaQuery.of(context).size.width * 0.9, 50.0),
        ),
      ),
      onPressed: () {},
      child: const SizedBox(
        height: 20,
        width: 20,
        child: Center(
          child: CircularProgressIndicator(color: Colors.white),
        ),
      ),
    );
  }
}
