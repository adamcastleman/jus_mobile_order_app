import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Models/product_model.dart';

class RecommendedCardWeb extends ConsumerWidget {
  final ProductModel recommended;

  const RecommendedCardWeb({required this.recommended, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container();
  }
}
