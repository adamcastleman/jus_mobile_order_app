import 'package:animations/animations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Models/product_model.dart';
import 'package:jus_mobile_order_app/Providers/product_providers.dart';
import 'package:jus_mobile_order_app/Views/cleanse_detail_page.dart';
import 'package:jus_mobile_order_app/Views/product_detail_page.dart';
import 'package:jus_mobile_order_app/Widgets/General/item_card_button_options.dart';
import 'package:jus_mobile_order_app/Widgets/Icons/new_icon.dart';
import 'package:jus_mobile_order_app/Widgets/Lists/product_description.dart';

import '../Helpers/loading.dart';

class ItemCardLarge extends HookConsumerWidget {
  final int index;

  const ItemCardLarge({required this.index, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final products = ref.watch(taxableProductsProvider);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
      child: products.when(
        loading: () => const Loading(),
        error: (Object e, _) => Text(
          e.toString(),
        ),
        data: (product) => OpenContainer(
          closedElevation: 2,
          openElevation: 2,
          tappable: false,
          transitionType: ContainerTransitionType.fadeThrough,
          transitionDuration: const Duration(milliseconds: 600),
          closedShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          openBuilder: (context, open) =>
              determineProductDetailPage(product[index]),
          closedBuilder: (context, close) => SizedBox(
            height: 400,
            child: Stack(
              children: [
                NewIcon(
                  product: product[index],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SizedBox(
                      height: 200,
                      child: CachedNetworkImage(
                        imageUrl: product[index].image,
                        progressIndicatorBuilder:
                            (context, url, downloadProgress) => const Loading(),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      ),
                    ),
                    Text(
                      product[index].name,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: ProductDescription(
                        products: product,
                        itemIndex: index,
                        fontSize: 14,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 22.0),
                      child: LargeItemCardActionsRow(
                          product: product[index], close: close),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  determineProductDetailPage(ProductModel product) {
    if (product.isScheduled) {
      return const CleanseDetailPage();
    } else {
      return ProductDetailPage(product: product);
    }
  }
}
