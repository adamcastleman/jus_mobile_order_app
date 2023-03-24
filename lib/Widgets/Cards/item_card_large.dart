import 'package:animations/animations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/formulas.dart';
import 'package:jus_mobile_order_app/Helpers/loading.dart';
import 'package:jus_mobile_order_app/Helpers/locations.dart';
import 'package:jus_mobile_order_app/Helpers/set_standard_ingredients.dart';
import 'package:jus_mobile_order_app/Helpers/set_standard_items.dart';
import 'package:jus_mobile_order_app/Helpers/spacing_widgets.dart';
import 'package:jus_mobile_order_app/Helpers/time.dart';
import 'package:jus_mobile_order_app/Models/product_model.dart';
import 'package:jus_mobile_order_app/Providers/ProviderWidgets/taxable_products_provider_widget.dart';
import 'package:jus_mobile_order_app/Providers/product_providers.dart';
import 'package:jus_mobile_order_app/Providers/theme_providers.dart';
import 'package:jus_mobile_order_app/Views/product_detail_page.dart';
import 'package:jus_mobile_order_app/Widgets/Icons/new_icon.dart';
import 'package:jus_mobile_order_app/Widgets/Lists/product_description.dart';

class LargeItemCard extends HookConsumerWidget {
  final int index;

  const LargeItemCard({required this.index, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final backgroundColor = ref.watch(backgroundColorProvider);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
      child: TaxableProductsProviderWidget(
        builder: (products) => OpenContainer(
          closedElevation: 0,
          openElevation: 0,
          openColor: backgroundColor,
          tappable: false,
          transitionType: ContainerTransitionType.fadeThrough,
          transitionDuration: const Duration(milliseconds: 600),
          closedShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          openBuilder: (context, open) => ProductDetailPage(
            product: products[index],
          ),
          closedBuilder: (context, close) {
            return InkWell(
              onTap: () {
                if (LocationHelper().selectedLocation(ref) == null) {
                  LocationHelper().chooseLocation(context, ref);
                  null;
                } else {
                  ref.read(selectedProductIDProvider.notifier).state =
                      products[index].productID;
                  ref.read(isScheduledProvider.notifier).state =
                      products[index].isScheduled;
                  products[index].isScheduled
                      ? StandardItems(ref: ref).set(products[index])
                      : StandardIngredients(ref: ref).set(products[index]);
                  ref.read(itemKeyProvider.notifier).state =
                      Formulas().idGenerator();
                  close();
                }
              },
              child: Consumer(
                builder: (context, ref, child) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15.0),
                  child: Stack(
                    children: [
                      determineDescriptorIcon(context, ref, products[index]),
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            SizedBox(
                              height: 200,
                              child: CachedNetworkImage(
                                imageUrl: products[index].image,
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
                                products[index].name,
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12.0,
                              ),
                              child: ProductDescription(
                                products: products,
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
            );
          },
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
      return Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: Image.asset('assets/sold_out.png', height: 75, width: 75),
      );
    } else {
      return product.isNew ? NewIcon(product: product) : const SizedBox();
    }
  }
}
