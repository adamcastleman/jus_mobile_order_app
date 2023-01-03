import 'package:flutter/material.dart';

class AnimatedListCard extends StatelessWidget {
  const AnimatedListCard({super.key});
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 120,
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    );
  }
}
