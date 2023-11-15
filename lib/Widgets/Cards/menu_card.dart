import 'package:animations/animations.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/locations.dart';
import 'package:jus_mobile_order_app/Helpers/products.dart';
import 'package:jus_mobile_order_app/Helpers/time.dart';
import 'package:jus_mobile_order_app/Models/product_model.dart';
import 'package:jus_mobile_order_app/Providers/ProviderWidgets/taxable_products_provider_widget.dart';
import 'package:jus_mobile_order_app/Providers/theme_providers.dart';
import 'package:jus_mobile_order_app/Views/product_detail_page.dart';
import 'package:jus_mobile_order_app/Widgets/Icons/new_icon.dart';

class MenuCard extends ConsumerWidget {
  final int index;
  const MenuCard({required this.index, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final backgroundColor = ref.watch(backgroundColorProvider);

    return TaxableProductsProviderWidget(
      builder: (products) => OpenContainer(
        openElevation: 0,
        closedElevation: 0,
        openColor: backgroundColor,
        closedColor: Colors.white,
        tappable: false,
        transitionDuration: const Duration(milliseconds: 600),
        closedShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        openBuilder: (context, open) => ProductDetailPage(
          product: products[index],
        ),
        closedBuilder: (context, close) {
          return InkWell(
            onTap: () async {
              HapticFeedback.lightImpact();
              if (LocationHelper().selectedLocation(ref) == null) {
                LocationHelper().chooseLocation(context, ref);
                null;
              } else {
                ProductHelpers(ref: ref).setProductProviders(products[index]);
                close();
              }
            },
            child: Consumer(
              builder: (context, ref, child) => Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 15.0, horizontal: 5.0),
                child: Stack(
                  children: [
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Hero(
                            tag: 'product-image',
                            child: SizedBox(
                              height: 150,
                              child: CachedNetworkImage(
                                imageUrl: products[index].image,
                              ),
                            ),
                          ),
                          AutoSizeText(
                            products[index].name,
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                            maxLines: 1,
                            textAlign: TextAlign.center,
                          ),
                          AutoSizeText(
                            products[index].description,
                            style: const TextStyle(fontSize: 12),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    determineDescriptorIcon(context, ref, products[index]),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget determineDescriptorIcon(
      BuildContext context, WidgetRef ref, ProductModel product) {
    final selectedLocation = LocationHelper().selectedLocation(ref);
    if (selectedLocation == null) {
      return product.isNew ? NewIcon(product: product) : const SizedBox();
    }

    final isAcceptingOrders = LocationHelper().acceptingOrders(ref) &&
        Time().acceptingOrders(context, ref);
    final isInStock = LocationHelper().productInStock(ref, product);

    if (!isAcceptingOrders && !product.isScheduled) {
      return const Padding(
        padding: EdgeInsets.only(left: 8.0),
        child: Icon(
          CupertinoIcons.nosign,
          size: 30,
        ),
      );
    } else if (!isInStock) {
      return Image.asset('assets/sold_out.png', height: 50, width: 50);
    } else {
      return product.isNew ? NewIcon(product: product) : const SizedBox();
    }
  }
}
