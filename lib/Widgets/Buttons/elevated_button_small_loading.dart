import 'package:flutter/material.dart';

class SmallElevatedLoadingButton extends StatelessWidget {
  const SmallElevatedLoadingButton({super.key});
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        minimumSize: MaterialStateProperty.all(
          Size(MediaQuery.of(context).size.width * 0.4, 35.0),
        ),
      ),
      onPressed: () {},
      child: const SizedBox(
        height: 10,
        width: 10,
        child: Center(
          child: CircularProgressIndicator(color: Colors.white),
        ),
      ),
    );
  }
}
