import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final backgroundColorProvider =
    Provider<Color>((ref) => const Color(0xffF5F5F7));

final selectedCardColorProvider =
    Provider<Color?>((ref) => Colors.blueGrey[50]);

final selectedCardBorderColorProvider =
    Provider<Color>((ref) => Colors.blueGrey);

final webFooterColorProvider =
    Provider<Color>((ref) => const Color(0xffD9E5D7));

final pastelRedProvider = Provider<Color>((ref) => const Color(0xffFFEEEC));

final pastelGreenProvider = Provider<Color>((ref) => const Color(0xffE0F1E6));

final darkGreenProvider = Provider<Color>((ref) => const Color(0xff1F3932));

final forestGreenProvider = Provider<Color>((ref) => const Color(0xff90B6A0));

final pastelBlueProvider = Provider<Color>((ref) => const Color(0xffEEF1F7));

final pastelBrownProvider = Provider<Color>((ref) => const Color(0xffEAE2D7));

final pastelPurpleProvider = Provider<Color>((ref) => const Color(0xffE9E5F0));

final pastelGreyProvider = Provider<Color>((ref) => const Color(0xffF2F2F2));

final pastelTanProvider = Provider<Color>((ref) => const Color(0xffF3F0EB));

final scaffoldTextStyleProvider = Provider<TextStyle>(
  (ref) => const TextStyle(fontSize: 26),
);

final titleStyleProvider = Provider<TextStyle>(
    (ref) => const TextStyle(fontSize: 14, fontWeight: FontWeight.bold));

final subtitleStyleProvider =
    Provider<TextStyle>((ref) => const TextStyle(fontSize: 12));

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

final priceLineThroughStyleProvider = Provider<TextStyle>(
  (ref) => const TextStyle(
    fontSize: 14,
    decoration: TextDecoration.lineThrough,
    color: Colors.grey,
  ),
);

final webNavigationButtonTextStyleProvider =
    Provider.family<TextStyle, double>((ref, fontSize) => TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
        ));
