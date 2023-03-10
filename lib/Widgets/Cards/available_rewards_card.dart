import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/error.dart';
import 'package:jus_mobile_order_app/Helpers/loading.dart';
import 'package:jus_mobile_order_app/Helpers/points.dart';
import 'package:jus_mobile_order_app/Models/points_details_model.dart';
import 'package:jus_mobile_order_app/Models/user_model.dart';
import 'package:jus_mobile_order_app/Providers/points_providers.dart';
import 'package:jus_mobile_order_app/Providers/product_providers.dart';
import 'package:jus_mobile_order_app/Providers/stream_providers.dart';
import 'package:jus_mobile_order_app/Widgets/General/selection_incrementor.dart';

import '../../Providers/discounts_provider.dart';

class AvailableRewardCard extends ConsumerWidget {
  final int index;
  const AvailableRewardCard({required this.index, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rewards = ref.watch(pointsDetailsProvider);
    final currentUser = ref.watch(currentUserProvider);
    return currentUser.when(
        error: (e, _) => ShowError(error: e.toString()),
        loading: () => const Loading(),
        data: (user) => rewards.when(
              error: (e, _) => ShowError(error: e.toString()),
              loading: () => const Loading(),
              data: (reward) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 18.0),
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
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AutoSizeText(
                                PointsHelper(ref: ref).availableRewards()[index]
                                    ['name'],
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                                maxLines: 2,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 5.0),
                                child: AutoSizeText(
                                  '${PointsHelper(ref: ref).availableRewards()[index]['amount']} points/ea',
                                  maxLines: 2,
                                ),
                              ),
                            ],
                          ),
                          SelectionIncrementer(
                            verticalPadding: 0,
                            horizontalPadding: 0,
                            buttonSpacing: 12,
                            iconSize: 20,
                            quantityRadius: 16,
                            quantity: determineQuantity(ref, index),
                            onAdd: () {
                              int pointsInUse = ref.watch(pointsInUseProvider);
                              int rewardAmount = PointsHelper(ref: ref)
                                  .availableRewards()[index]['amount'];
                              if (pointsInUse + rewardAmount >
                                  user.totalPoints!) {
                                return;
                              } else {
                                removeRewardPointsFromTotal(
                                    ref, index, reward, user);
                              }
                            },
                            onRemove: () {
                              if (ref.watch(discountTotalProvider).isEmpty) {
                                return;
                              } else {
                                returnRewardPointsToTotal(
                                    ref, reward, user, index);
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ));
  }

  determineQuantity(WidgetRef ref, int index) {
    if (ref.watch(rewardQuantityProvider).isEmpty) {
      return '0';
    } else {
      return ref.watch(rewardQuantityProvider)[index]['quantity'].toString();
    }
  }

  void removeRewardPointsFromTotal(
      WidgetRef ref, int index, PointsDetailsModel reward, UserModel user) {
    final currentOrder = ref.watch(currentOrderItemsProvider);
    final currentOrderCost = ref.watch(currentOrderCostProvider);

    final rewards = PointsHelper(ref: ref).availableRewards();
    final rewardAmount = rewards[index]['amount'];
    final numberOfAvailableRewards = rewards.length;

    final maxRewardQuantity = getProductQuantities(
      ref,
      currentOrder,
      rewards,
    );
    ref.read(rewardQuantityProvider.notifier).addReward(
          ref: ref,
          index: index,
          maxRewardQuantity: maxRewardQuantity,
          length: numberOfAvailableRewards,
          points: rewardAmount,
        );

    final discountAmounts = getDiscountAmounts(
      orderItems: currentOrder,
      rewardAmount: rewardAmount,
      orderCosts: currentOrderCost,
    );
    ref.read(discountTotalProvider.notifier).add(discountAmounts);
  }

  void returnRewardPointsToTotal(
      WidgetRef ref, PointsDetailsModel reward, UserModel user, int index) {
    int rewardAmount =
        PointsHelper(ref: ref).availableRewards()[index]['amount'];

    ref.read(rewardQuantityProvider.notifier).removeReward(
          ref: ref,
          rewards: ref.watch(rewardQuantityProvider),
          points: rewardAmount,
          index: index,
        );

    ref.read(discountTotalProvider.notifier).remove(rewardAmount);
  }

  Map<int, int> getProductQuantities(
      WidgetRef ref, List currentOrder, List availableRewards) {
    Map<int, int> result = {};

    for (var item in currentOrder) {
      int id = item['productID'];
      int itemQuantity = item['itemQuantity'] * item['daysQuantity'];

      for (var reward in availableRewards) {
        if (reward['products'].contains(id)) {
          int amount = reward['amount'];
          result[amount] = (result[amount] ?? 0) + itemQuantity;
        }
      }
    }

    return result;
  }

  List<Map<String, dynamic>> getDiscountAmounts({
    required List<Map<String, dynamic>> orderItems,
    required int rewardAmount,
    required List<Map<String, dynamic>> orderCosts,
  }) {
    List<Map<String, dynamic>> result = [];

    for (var orderItem in orderItems) {
      if (orderItem['points'] != rewardAmount) {
        continue;
      }

      var orderCost = orderCosts.firstWhere(
        (cost) => cost['itemKey'] == orderItem['itemKey'],
      );

      result.add({
        'price': orderCost['price'],
        'memberPrice': orderCost['memberPrice'],
        'itemKey': orderCost['itemKey'],
        'productID': orderItem['productID'],
        'itemQuantity': orderItem['itemQuantity'] * orderItem['daysQuantity'],
        'amount': rewardAmount,
        'source': 'points',
      });
    }

    return result;
  }
}
