import 'package:flutter/material.dart';

class OffersInUseTile extends StatelessWidget {
  const OffersInUseTile({super.key});

  @override
  Widget build(BuildContext context) {
    return const Align(
      alignment: Alignment.center,
      child: Center(
        child: Text(
          'Rewards cannot be combined with active offers that contain discounts.',
          style: TextStyle(fontSize: 18),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
