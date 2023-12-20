import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/spacing_widgets.dart';
import 'package:jus_mobile_order_app/Providers/ProviderWidgets/recommended_products_provider_widget.dart';

class WebHomeProductsCarousel extends ConsumerWidget {
  const WebHomeProductsCarousel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return RecommendedProductsProviderWidget(
      builder: (recommended) => Column(
        children: [
          const Row(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 8.0),
                child: Text(
                  'Popular Items',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 300,
            child: ListView.separated(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: recommended.length,
              separatorBuilder: (context, index) => Spacing.horizontal(24),
              itemBuilder: (context, index) => Container(),
            ),
          ),
          const SizedBox(
            height: 500,
          ),
        ],
      ),
    );
  }
}
