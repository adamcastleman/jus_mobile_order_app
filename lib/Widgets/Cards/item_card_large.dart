import 'package:animations/animations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Providers/product_providers.dart';
import 'package:jus_mobile_order_app/Providers/stream_providers.dart';
import 'package:jus_mobile_order_app/Providers/theme_providers.dart';
import 'package:jus_mobile_order_app/Views/product_detail_page.dart';
import 'package:jus_mobile_order_app/Widgets/Helpers/set_standard_ingredients.dart';
import 'package:jus_mobile_order_app/Widgets/Helpers/set_standard_items.dart';
import 'package:jus_mobile_order_app/Widgets/Helpers/spacing_widgets.dart';
import 'package:jus_mobile_order_app/Widgets/Icons/new_icon.dart';
import 'package:jus_mobile_order_app/Widgets/Lists/product_description.dart';

import '../Helpers/loading.dart';

class ItemCardLarge extends HookConsumerWidget {
  final int index;

  const ItemCardLarge({required this.index, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final products = ref.watch(taxableProductsProvider);
    final backgroundColor = ref.watch(themeColorProvider);
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
          openColor: backgroundColor!,
          tappable: false,
          transitionType: ContainerTransitionType.fadeThrough,
          transitionDuration: const Duration(milliseconds: 600),
          closedShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          openBuilder: (context, open) => ProductDetailPage(
            product: product[index],
          ),
          closedBuilder: (context, close) => InkWell(
            onTap: () {
              ref.read(isScheduledProvider.notifier).state =
                  product[index].isScheduled;
              product[index].isScheduled
                  ? StandardItems(ref: ref).set(product[index])
                  : StandardIngredients(ref: ref).set(product[index]);
              close();
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 15.0),
              child: Stack(
                children: [
                  NewIcon(
                    product: product[index],
                  ),
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      // crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 200,
                          child: CachedNetworkImage(
                            imageUrl: product[index].image,
                            progressIndicatorBuilder:
                                (context, url, downloadProgress) =>
                                    const Loading(),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          ),
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.only(top: 15.0, bottom: 5.0),
                          child: Text(
                            product[index].name,
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12.0,
                          ),
                          child: ProductDescription(
                            products: product,
                            itemIndex: index,
                            fontSize: 14,
                          ),
                        ),
                        Spacing().vertical(10),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
