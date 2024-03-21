import 'package:flutter/material.dart';

class PausedMembershipBanner extends StatelessWidget {
  const PausedMembershipBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      child: Container(
        height: 50,
        width: MediaQuery.of(context).size.width,
        color: Colors.red,
        child: const Center(
          child: Text(
            'There was an error processing your membership payment. Your membership is paused. Please update your payment method.',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
