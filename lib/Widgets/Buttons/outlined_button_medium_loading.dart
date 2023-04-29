import 'package:flutter/material.dart';

class MediumOutlineLoadingButton extends StatelessWidget {
  const MediumOutlineLoadingButton({super.key});
  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () {},
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Colors.white),
        minimumSize: MaterialStateProperty.all(
          Size(MediaQuery.of(context).size.width * 0.4, 45.0),
        ),
      ),
      child: const SizedBox(
        height: 20,
        width: 20,
        child: Center(
          child: CircularProgressIndicator(color: Colors.black),
        ),
      ),
    );
  }
}
