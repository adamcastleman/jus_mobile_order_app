import 'package:flutter/material.dart';

class JusDivider {
  thick() {
    return const Divider(
      color: Colors.black,
      thickness: 1.0,
    );
  }

  thin() {
    return const Divider(
      thickness: 0.5,
    );
  }
}
