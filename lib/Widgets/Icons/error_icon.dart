import 'package:flutter/material.dart';

class ErrorIcon extends StatelessWidget {
  final double? iconSize;
  const ErrorIcon({this.iconSize, super.key});

  @override
  Widget build(BuildContext context) {
    return Icon(Icons.error, size: iconSize ?? 50.0, color: Colors.black);
  }
}
