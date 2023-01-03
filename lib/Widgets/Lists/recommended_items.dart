import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Models/product_model.dart';
import 'package:jus_mobile_order_app/Providers/product_providers.dart';
import 'package:jus_mobile_order_app/Widgets/Cards/item_card_small.dart';
import 'package:jus_mobile_order_app/Widgets/Helpers/spacing_widgets.dart';

class RecommendedItems extends ConsumerWidget {
  const RecommendedItems({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<List<ProductModel>> products =
        ref.watch(recommendedProductsProvider);

    return SizedBox(
      height: 400,
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.05),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Recommended For You',
              style: Theme.of(context).textTheme.bodyText2,
            ),
            Spacing().vertical(10.0),
            Expanded(
              child: ListView.separated(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: products.value?.length ?? 0,
                separatorBuilder: (context, index) => Spacing().horizontal(5),
                itemBuilder: (context, index) => SmallItemCard(
                  index: index,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
