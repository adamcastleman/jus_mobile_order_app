import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/spacing_widgets.dart';
import 'package:jus_mobile_order_app/Providers/ProviderWidgets/new_products_provider_widget.dart';
import 'package:jus_mobile_order_app/Widgets/Cards/new_product_card.dart';

class NewProductList extends ConsumerWidget {
  const NewProductList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return NewProductsProviderWidget(
      builder: (products) => SizedBox(
        height: 270,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'New',
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
                  itemCount: products.isEmpty ? 0 : products.length,
                  itemBuilder: (context, index) => NewProductCard(index: index),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
