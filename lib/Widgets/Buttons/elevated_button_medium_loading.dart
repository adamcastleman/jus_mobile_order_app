import 'package:flutter/material.dart';

class MediumElevatedLoadingButton extends StatelessWidget {
  const MediumElevatedLoadingButton({super.key});
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        minimumSize: MaterialStateProperty.all(
          Size(MediaQuery.of(context).size.width * 0.4, 45.0),
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
