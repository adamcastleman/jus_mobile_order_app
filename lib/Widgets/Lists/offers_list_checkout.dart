import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/error.dart';
import 'package:jus_mobile_order_app/Helpers/loading.dart';
import 'package:jus_mobile_order_app/Helpers/points.dart';
import 'package:jus_mobile_order_app/Helpers/spacing_widgets.dart';
import 'package:jus_mobile_order_app/Helpers/time.dart';
import 'package:jus_mobile_order_app/Models/offers_model.dart';
import 'package:jus_mobile_order_app/Models/points_details_model.dart';
import 'package:jus_mobile_order_app/Providers/discounts_provider.dart';
import 'package:jus_mobile_order_app/Providers/offers_providers.dart';
import 'package:jus_mobile_order_app/Providers/payments_providers.dart';
import 'package:jus_mobile_order_app/Providers/points_providers.dart';
import 'package:jus_mobile_order_app/Providers/product_providers.dart';
import 'package:jus_mobile_order_app/Providers/stream_providers.dart';
import 'package:jus_mobile_order_app/Widgets/General/cart_category_descriptor.dart';
import 'package:jus_mobile_order_app/Widgets/General/selection_incrementor.dart';

class AvailableOffersList extends ConsumerWidget {
  const AvailableOffersList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserProvider);
    final rewards = ref.watch(pointsDetailsProvider);
    final availableOffers = ref.watch(offersProvider);
    return currentUser.when(
      error: (e, _) => ShowError(error: e.toString()),
      loading: () => const Loading(),
      data: (user) => rewards.when(
        error: (e, _) => ShowError(error: e.toString()),
        loading: () => const Loading(),
        data: (reward) => availableOffers.when(
          error: (e, _) => ShowError(error: e.toString()),
          loading: () => const Loading(),
          data: (offers) {
            if (user.uid == null) {
              return const SizedBox();
            }
            if (offers.isEmpty) {
              return const SizedBox();
            }

            bool allMemberOnly = true;
            for (var offer in offers) {
              if (!offer.isMemberOnly) {
                allMemberOnly = false;
                break;
              }
            }

            if (allMemberOnly && !user.isActiveMember!) {
              return const SizedBox();
            } else {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CartCategory(text: 'Offers'),
                  qualifyingOffers(ref, offers).isEmpty
                      ? noQualifyingOffers()
                      : SizedBox(
                          height: 200,
                          child: ListView.separated(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 15.0,
                            ),
                            primary: false,
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemCount: qualifyingOffers(ref, offers).length,
                            separatorBuilder: (context, index) =>
                                Spacing().horizontal(10),
                            itemBuilder: (context, index) {
                              return offerCard(context, ref, index,
                                  qualifyingOffers(ref, offers), reward);
                            },
                          ),
                        ),
                ],
              );
            }
          },
        ),
      ),
    );
  }

  Widget offerCard(BuildContext context, WidgetRef ref, int index,
      List<OffersModel> offers, PointsDetailsModel reward) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: SizedBox(
        width: 150,
        child: Card(
          elevation: 3,
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: const BorderSide(color: Colors.black, width: 0.5),
          ),
          child: Padding(
            padding: const EdgeInsets.only(
                left: 8.0, right: 8.0, top: 8.0, bottom: 18.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AutoSizeText(
                  offers[index].name,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                  maxLines: 2,
                ),
                AutoSizeText(
                  offers[index].description,
                  style: const TextStyle(fontSize: 13),
                  maxLines: 2,
                ),
                buildOfferButton(ref, index, offers),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildOfferButton(WidgetRef ref, int index, List<OffersModel> offers) {
    final offer = offers[index];
    final isOfferActive = DateTime.now().isAfter(offer.startDate) &&
        DateTime.now().isBefore(offer.endDate);

    if (isOfferActive && offer.pointsMultiple > 1) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ref.watch(pointsMultiplierProvider) != 1
              ? Padding(
                  padding: const EdgeInsets.only(left: 4.0),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.check_circle_outline,
                        color: Colors.green,
                      ),
                      Text(
                        '${PointsHelper(ref: ref).determinePointsMultipleText(isJusCard: ref.watch(selectedCreditCardProvider)['isGiftCard'] ?? false)}/\$1',
                        style: const TextStyle(fontSize: 11),
                      ),
                    ],
                  ),
                )
              : const SizedBox(),
          Spacing().horizontal(8.0),
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: InkWell(
              onTap: () {
                HapticFeedback.lightImpact();
                ref.read(pointsMultiplierProvider) == 1
                    ? ref.read(pointsMultiplierProvider.notifier).state =
                        offer.pointsMultiple
                    : ref.read(pointsMultiplierProvider.notifier).state = 1;
              },
              child: ref.watch(pointsMultiplierProvider) == 1
                  ? const Icon(
                      CupertinoIcons.add_circled_solid,
                      color: Colors.black,
                      size: 34,
                    )
                  : const Icon(
                      CupertinoIcons.minus_circle_fill,
                      color: Colors.black,
                      size: 34,
                    ),
            ),
          ),
        ],
      );
    } else if (isOfferActive && offer.pointsMultiple <= 1) {
      return SelectionIncrementer(
        verticalPadding: 0,
        horizontalPadding: 0,
        buttonSpacing: 12,
        iconSize: 20,
        quantityRadius: 16,
        quantity: determineQuantity(ref, index),
        onAdd: () {
          invalidateRewardsProviders(ref);
          final itemQuantity = calculateItemQuantity(ref, index, offers);
          final maxItems = calculateMaxItems(itemQuantity, offer.itemLimit);

          checkAndAddOffers(ref, index, maxItems, offers);
        },
        onRemove: () {
          if (ref
              .read(offersQuantityProvider)
              .any((element) => element['quantity'] != 0)) {
            ref.read(offersQuantityProvider.notifier).remove(ref, index);

            ref
                .read(discountTotalProvider.notifier)
                .remove(getPointsValue(ref, index, offers));
          } else {
            return;
          }
        },
      );
    } else {
      return AutoSizeText(
        Time().formatDateRange(offer.startDate, offer.endDate),
        maxLines: 1,
        style: const TextStyle(fontSize: 24),
      );
    }
  }

  invalidateRewardsProviders(WidgetRef ref) {
    ref.invalidate(rewardQuantityProvider);
    ref.read(discountTotalProvider.notifier).removeRewardDiscount();
    ref.invalidate(pointsInUseProvider);
    ref.read(isRewardsAvailableProvider.notifier).state = false;
  }

  int calculateItemQuantity(
      WidgetRef ref, int index, List<OffersModel> offers) {
    int itemQuantity = 0;
    int daysQuantity = 1;
    int total = 0;
    for (var item in getQualifyingItems(ref, index, offers)) {
      itemQuantity = item['itemQuantity'] as int;
      daysQuantity = item['daysQuantity'] as int;
      total += itemQuantity * daysQuantity;
    }
    return total;
  }

  int calculateMaxItems(int itemQuantity, int itemLimit) {
    if (itemLimit == 0) {
      return itemQuantity;
    }
    if (itemLimit < itemQuantity) {
      return itemLimit;
    }
    return itemQuantity;
  }

  determineQuantity(WidgetRef ref, int index) {
    if (ref.watch(offersQuantityProvider).isEmpty) {
      return '0';
    } else {
      return ref.watch(offersQuantityProvider)[index]['quantity'].toString();
    }
  }

  List<OffersModel> qualifyingOffers(WidgetRef ref, List<OffersModel> offers) {
    final currentOrder = ref.watch(currentOrderItemsProvider);
    return offers
        .where(
          (offer) => currentOrder.any((order) =>
              offer.qualifyingProducts.contains(order['productID']) ||
              offer.pointsMultiple != 1),
        )
        .toList();
  }

  noQualifyingOffers() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 65.0),
      child: Align(
        alignment: Alignment.center,
        child: Center(
          child: Text(
            'No qualifying offers available',
            style: TextStyle(fontSize: 18),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  List<Map<String, dynamic>> getQualifyingItems(
      WidgetRef ref, int index, List<OffersModel> offers) {
    final currentOrder = ref.watch(currentOrderItemsProvider);
    return currentOrder
        .where((element) => offers[index]
            .qualifyingProducts
            .contains(element['productID'] as int))
        .toList();
  }

  int getPointsValue(WidgetRef ref, int index, List<OffersModel> offers) {
    final qualifyingItems = getQualifyingItems(ref, index, offers);
    if (qualifyingItems.isEmpty) {
      return 0;
    }
    final itemKey = qualifyingItems
        .firstWhere((item) => ref.read(discountTotalProvider).any(
            (discountItem) =>
                discountItem['itemKey']?.toString() ==
                item['itemKey']?.toString()))['itemKey']
        ?.toString();
    final matchingDiscountItems = ref.read(discountTotalProvider).where(
        (discountItem) => discountItem['itemKey']?.toString() == itemKey);
    if (matchingDiscountItems.isEmpty) {
      return 0;
    }
    final lowestAmountItem = matchingDiscountItems
        .reduce((a, b) => a['amount'] < b['amount'] ? a : b);
    return lowestAmountItem['amount'];
  }

  List<Map<String, dynamic>> getQualifyingOrderCosts(
      WidgetRef ref, OffersModel offer) {
    final currentOrder = ref.watch(currentOrderItemsProvider);
    final currentOrderCost = ref.watch(currentOrderCostProvider);

    final qualifyingProductsInOffers = currentOrder
        .where((item) => offer.qualifyingProducts.contains(item['productID']))
        .toList();

    final qualifyingCostsInOffers = currentOrderCost
        .where((cost) => qualifyingProductsInOffers
            .any((product) => cost['itemKey'] == product['itemKey']))
        .map((cost) => Map<String, dynamic>.from({
              'itemKey': cost['itemKey'],
              'price': cost['price'],
              'memberPrice': cost['memberPrice'],
              'points': cost['points'],
            }))
        .toList();

    final addToDiscountMap = qualifyingCostsInOffers.map((cost) {
      return {
        'price': (cost['price'] * offer.discount) / 100,
        'memberPrice': (cost['memberPrice'] * offer.discount) / 100,
        'itemKey': cost['itemKey'],
        'itemQuantity': 0,
        'amount': cost['points'],
        'source': 'offer',
      };
    }).toList();

    for (var product in qualifyingProductsInOffers) {
      final matchingCost = addToDiscountMap.firstWhere(
        (cost) => cost['itemKey'] == product['itemKey'],
      );

      matchingCost['itemQuantity'] +=
          product['itemQuantity'] * product['daysQuantity'];
    }

    final updatedMap = <String, Map<String, dynamic>>{};
    for (final map in addToDiscountMap) {
      final itemKey = map['itemKey'] as String;
      if (!updatedMap.containsKey(itemKey)) {
        updatedMap[itemKey] = {
          'itemKey': itemKey,
          'itemQuantity': map['itemQuantity'] as int,
          'price': map['price'] as double,
          'memberPrice': map['memberPrice'] as double,
          'source': 'offer',
          'amount': map['amount'] as int,
        };
      } else {
        final updatedQuantity = (updatedMap[itemKey]!['itemQuantity'] as int) +
            (map['itemQuantity'] as int);
        updatedMap[itemKey]!['itemQuantity'] = updatedQuantity;
      }
    }

    final updatedList = updatedMap.values.toList();
    return updatedList;
  }

  checkAndAddOffers(
      WidgetRef ref, int index, int maxItems, List<OffersModel> offers) {
    if (ref.read(offersQuantityProvider).isEmpty ||
        ref.read(offersQuantityProvider)[index]['quantity'] < maxItems) {
      ref.read(offersQuantityProvider.notifier).add(
            ref,
            index,
            offers.length,
            maxItems,
          );
      ref
          .read(discountTotalProvider.notifier)
          .add(getQualifyingOrderCosts(ref, offers[index]));
    } else {
      return;
    }
  }
}
