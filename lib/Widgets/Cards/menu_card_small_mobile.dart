import 'package:animations/animations.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/locations.dart';
import 'package:jus_mobile_order_app/Helpers/spacing_widgets.dart';
import 'package:jus_mobile_order_app/Models/product_model.dart';
import 'package:jus_mobile_order_app/Providers/location_providers.dart';
import 'package:jus_mobile_order_app/Providers/product_providers.dart';
import 'package:jus_mobile_order_app/Views/product_detail_page.dart';

class MenuCardSmallMobile extends ConsumerWidget {
  final ProductModel product;
  final Function() providerFunction;
  final String? favoriteName;

  const MenuCardSmallMobile({
    required this.product,
    required this.providerFunction,
    this.favoriteName,
    super.key,
  });
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return OpenContainer(
      openElevation: 0,
      closedElevation: 0,
      closedShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      tappable: false,
      transitionDuration: const Duration(milliseconds: 600),
      openBuilder: (context, open) {
        return ProductDetailPage(
          product: product,
        );
      },
      closedBuilder: (context, close) {
        return InkWell(
          onTap: () {
            HapticFeedback.lightImpact();
            if (ref.read(selectedLocationProvider) == null) {
              LocationHelper().chooseLocation(context, ref);
            } else {
              providerFunction();
              close();
            }
          },
          child: SizedBox(
            width: 150,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
              child: Column(
                children: [
                  Hero(
                    tag: 'product-image',
                    child: SizedBox(
                      height: ref.watch(isFavoritesSheetProvider) ? 160 : 130,
                      width: 100,
                      child: CachedNetworkImage(
                        imageUrl: product.image,
                      ),
                    ),
                  ),
                  Spacing.vertical(15),
                  AutoSizeText(
                    favoriteName == null ? product.name : favoriteName!,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
