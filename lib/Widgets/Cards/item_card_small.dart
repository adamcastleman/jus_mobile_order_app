import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Models/product_model.dart';
import 'package:jus_mobile_order_app/Providers/product_providers.dart';
import 'package:jus_mobile_order_app/Widgets/Helpers/loading.dart';
import 'package:jus_mobile_order_app/Widgets/Lists/product_description.dart';

class SmallItemCard extends ConsumerWidget {
  final int index;

  const SmallItemCard({required this.index, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<List<ProductModel>> products =
        ref.watch(recommendedProductsProvider);
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.55,
      child: Card(
        child: Center(
          child: products.when(
            data: (List<ProductModel> products) =>
                buildCard(products, index, ref),
            error: (Object e, StackTrace trace) => Text(trace.toString()),
            loading: () => const Loading(),
          ),
        ),
      ),
    );
  }

  buildCard(List<ProductModel> products, int index, WidgetRef ref) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              height: 150,
              child: CachedNetworkImage(
                imageUrl: products[index].image,
                progressIndicatorBuilder: (context, url, downloadProgress) =>
                    const Loading(),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: AutoSizeText(
                products[index].name,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                maxLines: 1,
              ),
            ),
          ],
        ),
        ProductDescription(
          products: products,
          itemIndex: index,
          fontSize: 14,
        ),
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                pricingColumn(products, index),
                // ItemCardFAB(
                //   product: products[index],
                // ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  pricingColumn(List<ProductModel> products, int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
      child: Column(
        children: [
          Column(
            children: [
              Text(
                '\$${(products[index].price[0]['amount'] / 100).toStringAsFixed(2)}',
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                '${products[index].price[0]['name']}',
                style: const TextStyle(fontSize: 12),
              ),
            ],
          ),
          Column(
            children: [
              Text(
                '\$${(products[index].memberPrice[0]['amount'] / 100).toStringAsFixed(2)}',
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                '${products[index].memberPrice[0]['name']}',
                style: const TextStyle(fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
