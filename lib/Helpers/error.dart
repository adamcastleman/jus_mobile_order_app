import 'package:flutter/material.dart';

class ShowError extends StatelessWidget {
  final String? error;

  const ShowError({this.error, super.key});
  @override
  Widget build(BuildContext context) {
    if (error == null) {
      return const SizedBox();
    } else {
      debugPrint(error);
      return Text(
        error!,
        style: const TextStyle(
          color: Colors.red,
        ),
        textAlign: TextAlign.center,
      );
    }
  }
}
