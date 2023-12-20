import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/products.dart';
import 'package:jus_mobile_order_app/Models/product_model.dart';
import 'package:jus_mobile_order_app/Widgets/Cards/menu_card_small_mobile.dart';

class RecommendedCardMobile extends ConsumerWidget {
  final ProductModel recommended;

  const RecommendedCardMobile({required this.recommended, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MenuCardSmallMobile(
      product: recommended,
      providerFunction: () =>
          ProductHelpers(ref: ref).setProductProviders(recommended),
    );
  }
}
