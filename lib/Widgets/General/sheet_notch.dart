import 'package:flutter/material.dart';

class SheetNotch extends StatelessWidget {
  const SheetNotch({super.key});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.only(top: 8),
        height: 3,
        width: 60,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100), color: Colors.black),
      ),
    );
  }
}
