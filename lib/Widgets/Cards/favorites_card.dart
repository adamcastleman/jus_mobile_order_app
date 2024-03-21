import 'package:animations/animations.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/navigation.dart';
import 'package:jus_mobile_order_app/Helpers/products.dart';
import 'package:jus_mobile_order_app/Helpers/spacing_widgets.dart';
import 'package:jus_mobile_order_app/Models/favorites_model.dart';
import 'package:jus_mobile_order_app/Models/product_model.dart';
import 'package:jus_mobile_order_app/Providers/location_providers.dart';
import 'package:jus_mobile_order_app/Providers/product_providers.dart';
import 'package:jus_mobile_order_app/Providers/theme_providers.dart';
import 'package:jus_mobile_order_app/Views/product_detail_page.dart';

class FavoritesCard extends ConsumerWidget {
  final FavoritesModel favoriteItem;
  final double imageWidth;
  final double imageHeight;

  const FavoritesCard({
    required this.favoriteItem,
    required this.imageWidth,
    required this.imageHeight,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final backgroundColor = ref.watch(backgroundColorProvider);
    final pastelTan = ref.watch(pastelTanProvider);
    final products = ref.watch(allProductsProvider);
    final product =
        products.firstWhere((item) => item.productId == favoriteItem.productId);
    final ingredients = ref.watch(allIngredientsProvider);

    return OpenContainer(
      openElevation: 0,
      closedElevation: 0,
      openColor: backgroundColor,
      closedColor: backgroundColor,
      tappable: false,
      transitionDuration: const Duration(milliseconds: 600),
      closedShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      openBuilder: (context, open) {
        return SafeArea(
          bottom: false,
          top: false,
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
      closedBuilder: (context, close) => _buildClosedContainer(
        context,
        ref,
        close,
        product,
        pastelTan,
      ),
    );
  }

  Widget _buildClosedContainer(
    BuildContext context,
    WidgetRef ref,
    VoidCallback close,
    ProductModel product,
    Color pastelBrown,
  ) {
    return InkWell(
      onTap: () => _handleTap(context, ref, close, product),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProductImage(product, pastelBrown),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: _buildProductName(product),
              ),
              _buildOrderNowRow(),
            ],
          ),
        ),
      ),
    );
  }

  void _handleTap(BuildContext context, WidgetRef ref, VoidCallback close,
      ProductModel currentProduct) {
    HapticFeedback.lightImpact();
    if (ref.read(selectedLocationProvider).uid.isEmpty) {
      NavigationHelpers().navigateToLocationPage(context, ref);
    } else {
      ProductHelpers().setFavoritesProviders(ref, currentProduct, favoriteItem);
      close();
    }
  }

  Widget _buildProductImage(ProductModel currentProduct, Color pastelBrown) {
    return Flexible(
      child: Hero(
        tag: 'product-image-${currentProduct.productId}',
        child: SizedBox(
          width: 330, // The width of the card
          child: Card(
            color: pastelBrown,
            child: Center(
              // Center the image within the Card
              child: SizedBox(
                // Specify the size of the image smaller than the card
                width: imageWidth,
                height: imageHeight,
                child: CachedNetworkImage(
                  imageUrl: currentProduct.image,
                  fit: BoxFit.contain, // Ensure the entire image is visible
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProductName(ProductModel currentProduct) {
    return AutoSizeText(
      favoriteItem.name.isEmpty ? currentProduct.name : favoriteItem.name,
      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      maxLines: 2,
      textAlign: TextAlign.center,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildOrderNowRow() {
    return Row(
      children: [
        const Text(
          'Order now',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        Spacing.vertical(8),
        const Icon(
          CupertinoIcons.arrow_right,
          size: 20,
        ),
      ],
    );
  }
}
