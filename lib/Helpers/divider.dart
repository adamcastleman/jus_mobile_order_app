import 'package:flutter/material.dart';

class JusDivider {
  static thick() {
    return const Divider(
      color: Colors.black,
      thickness: 0.5,
    );
  }

  static thin() {
    return const Divider(
      thickness: 0.5,
    );
  }
}
