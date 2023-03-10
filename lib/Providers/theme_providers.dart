import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final backgroundColorProvider =
    Provider<Color>((ref) => const Color(0xffF5F5F7));

final selectedCardColorProvider =
    Provider<Color?>((ref) => Colors.blueGrey[50]);

final selectedCardBorderColorProvider =
    Provider<Color>((ref) => Colors.blueGrey);

final priceBoldProvider = Provider<TextStyle>(
  (ref) => const TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 20,
  ),
);

final priceNormalStyleProvider =
    Provider<TextStyle>((ref) => const TextStyle(fontSize: 17));

final priceGreenStyleProvider = Provider<TextStyle>(
  (ref) => const TextStyle(
    fontSize: 17,
    color: Colors.green,
  ),
);

final priceLineThroughStyle = Provider<TextStyle>(
  (ref) => const TextStyle(
    fontSize: 14,
    decoration: TextDecoration.lineThrough,
    color: Colors.grey,
  ),
);
