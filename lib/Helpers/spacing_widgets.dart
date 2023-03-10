import 'package:flutter/material.dart';

class Spacing {
  vertical(double spacing) {
    return SizedBox(
      height: spacing,
    );
  }

  horizontal(double spacing) {
    return SizedBox(
      width: spacing,
    );
  }
}
