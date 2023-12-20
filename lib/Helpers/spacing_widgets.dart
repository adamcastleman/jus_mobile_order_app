import 'package:flutter/material.dart';

class Spacing {
  static vertical(double spacing) {
    return SizedBox(
      height: spacing,
    );
  }

  static horizontal(double spacing) {
    return SizedBox(
      width: spacing,
    );
  }
}
