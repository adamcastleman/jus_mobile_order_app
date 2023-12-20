import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/spacing_widgets.dart';
import 'package:jus_mobile_order_app/Providers/ProviderWidgets/recommended_products_provider_widget.dart';
import 'package:jus_mobile_order_app/Widgets/Cards/recommended_card.dart';

class RecommendedList extends ConsumerWidget {
  const RecommendedList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return RecommendedProductsProviderWidget(
      builder: (recommended) => SizedBox(
        height: 270,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Recommended for you',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.centerLeft,
                child: ListView.separated(
                  shrinkWrap: true,
                  primary: false,
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  scrollDirection: Axis.horizontal,
                  separatorBuilder: (context, index) => Spacing.horizontal(15),
                  itemCount: recommended.isEmpty ? 0 : recommended.length,
                  itemBuilder: (context, index) => RecommendedCardMobile(
                    recommended: recommended[index],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
