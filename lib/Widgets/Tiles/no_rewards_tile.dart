import 'package:flutter/material.dart';

class NoRewardsTile extends StatelessWidget {
  const NoRewardsTile({super.key});

  @override
  Widget build(BuildContext context) {
    return const Align(
      alignment: Alignment.center,
      child: Center(
        child: Text(
          'No rewards available',
          style: TextStyle(fontSize: 18),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
