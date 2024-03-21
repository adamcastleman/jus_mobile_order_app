import 'package:animations/animations.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/locations.dart';
import 'package:jus_mobile_order_app/Helpers/navigation.dart';
import 'package:jus_mobile_order_app/Helpers/products.dart';
import 'package:jus_mobile_order_app/Helpers/time.dart';
import 'package:jus_mobile_order_app/Helpers/utilities.dart';
import 'package:jus_mobile_order_app/Models/product_model.dart';
import 'package:jus_mobile_order_app/Providers/product_providers.dart';
import 'package:jus_mobile_order_app/Providers/theme_providers.dart';
import 'package:jus_mobile_order_app/Views/product_detail_page.dart';
import 'package:jus_mobile_order_app/Widgets/Icons/new_icon.dart';

class MenuCard extends ConsumerWidget {
  final ProductModel product;

  const MenuCard({required this.product, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final backgroundColor = ref.watch(backgroundColorProvider);
    final ingredients = ref.watch(allIngredientsProvider);
    return OpenContainer(
      openElevation: 0,
      closedElevation: 0,
      openColor: backgroundColor,
      closedColor: Colors.white,
      tappable: false,
      transitionType: ContainerTransitionType.fadeThrough,
      transitionDuration: const Duration(milliseconds: 500),
      closedShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      openBuilder: (context, open) {
        return SafeArea(
          bottom: false,
          child: ProductDetailPage(
            product: product,
            ingredients: ingredients,
            //This handles page changes when we interact with buttons like
            //member pricing info, etc. for Web.
            onNavigationChange: () {
              NavigationHelpers.handleMembershipNavigationOnWeb(context, ref);
            },
          ),
        );
      },
      closedBuilder: (context, close) => _menuCardWidget(context, ref, close),
    );
  }

  Widget _menuCardWidget(BuildContext context, WidgetRef ref, Function close) {
    return InkWell(
      onTap: () async {
        HapticFeedback.lightImpact();
        if (LocationHelper().selectedLocation(ref) == null) {
          NavigationHelpers().navigateToLocationPage(context, ref);
        } else {
          ProductHelpers().setProductProviders(ref, product);
          close();
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 5.0),
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Hero(
                    tag: 'product-image',
                    child: AspectRatio(
                      aspectRatio: ResponsiveLayout.isMobileBrowser(context) ||
                              ResponsiveLayout.isTablet(context)
                          ? 1.20
                          : 1.5,
                      child: SizedBox(
                        child: CachedNetworkImage(
                          imageUrl: product.image,
                        ),
                      ),
                    ),
                  ),
                  AutoSizeText(
                    product.name,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                    maxLines: 1,
                    textAlign: TextAlign.center,
                  ),
                  AutoSizeText(
                    product.description,
                    style: const TextStyle(fontSize: 12),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            determineDescriptorIcon(context, ref, product),
          ],
        ),
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
    final isInStock = LocationHelper().isProductInStock(ref, product);

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
