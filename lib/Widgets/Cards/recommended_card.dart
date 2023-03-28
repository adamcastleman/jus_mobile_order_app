import 'package:animations/animations.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/formulas.dart';
import 'package:jus_mobile_order_app/Helpers/locations.dart';
import 'package:jus_mobile_order_app/Helpers/set_standard_ingredients.dart';
import 'package:jus_mobile_order_app/Helpers/set_standard_items.dart';
import 'package:jus_mobile_order_app/Helpers/spacing_widgets.dart';
import 'package:jus_mobile_order_app/Providers/ProviderWidgets/recommended_products_provider_widget.dart';
import 'package:jus_mobile_order_app/Providers/product_providers.dart';
import 'package:jus_mobile_order_app/Views/product_detail_page.dart';

class RecommendedCard extends ConsumerWidget {
  final int index;

  const RecommendedCard({required this.index, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return RecommendedProductsProviderWidget(
      builder: (recommended) => OpenContainer(
        openElevation: 0,
        closedElevation: 0,
        closedShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        tappable: false,
        transitionDuration: const Duration(milliseconds: 600),
        openBuilder: (context, open) {
          return ProductDetailPage(
            product: recommended[index],
          );
        },
        closedBuilder: (context, close) {
          return InkWell(
            onTap: () {
              if (LocationHelper().selectedLocation(ref) == null) {
                LocationHelper().chooseLocation(context, ref);
                null;
              } else {
                ref.read(selectedProductIDProvider.notifier).state =
                    recommended[index].productID;
                ref.read(isScheduledProvider.notifier).state =
                    recommended[index].isScheduled;
                recommended[index].isScheduled
                    ? StandardItems(ref: ref).set(recommended[index])
                    : StandardIngredients(ref: ref).set(recommended[index]);

                ref.read(itemKeyProvider.notifier).state =
                    Formulas().idGenerator();
                close();
              }
            },
            child: SizedBox(
              width: 150,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 12.0, horizontal: 12.0),
                child: Column(
                  children: [
                    Hero(
                      tag: 'product-image',
                      child: SizedBox(
                        height: 130,
                        width: 100,
                        child: CachedNetworkImage(
                          imageUrl: recommended[index].image,
                        ),
                      ),
                    ),
                    Spacing().vertical(15),
                    AutoSizeText(
                      recommended[index].name,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                      maxLines: 2,
                      textAlign: TextAlign.center,
                    ),
                    Spacing().vertical(5),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
