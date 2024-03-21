import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:jus_mobile_order_app/Helpers/navigation.dart';
import 'package:jus_mobile_order_app/Helpers/points.dart';
import 'package:jus_mobile_order_app/Helpers/spacing_widgets.dart';
import 'package:jus_mobile_order_app/Providers/points_providers.dart';
import 'package:jus_mobile_order_app/Providers/stream_providers.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/info_button.dart';
import 'package:jus_mobile_order_app/Widgets/Cards/available_rewards_card.dart';
import 'package:jus_mobile_order_app/Widgets/Tiles/no_rewards_tile.dart';
import 'package:jus_mobile_order_app/Widgets/Tiles/offer_in_use_tile.dart';
import 'package:jus_mobile_order_app/Widgets/Tiles/rewards_guest_checkout.dart';

class RewardsList extends ConsumerWidget {
  const RewardsList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider).value!;
    final points = ref.watch(pointsInformationProvider);
    final pointsInUse = ref.watch(pointsInUseProvider);
    final isRewardsAvailable = ref.watch(isRewardsAvailableProvider);
    return user.uid == null
        ? const RewardsGuestCheckout()
        : SizedBox(
            height:
                PointsHelper().availableRewards(ref, user, points).isEmpty ||
                        isRewardsAvailable == false
                    ? 150
                    : 250,
            child: Stack(
              children: [
                Row(
                  children: [
                    PointsHelper().availableRewards(ref, user, points).isEmpty
                        ? Text(
                            'Available Points: ${NumberFormat('#,###').format(user.points!)}')
                        : Text(
                            'Points: ${NumberFormat('#,###').format(pointsInUse)} / ${NumberFormat('#,###').format(user.points!)}',
                            style: const TextStyle(fontSize: 16),
                          ),
                    Spacing.horizontal(5),
                    InfoButton(
                      onTap: () {
                        HapticFeedback.lightImpact();
                        NavigationHelpers.navigateToPointsInformationPage(
                            context, ref);
                      },
                      size: 18,
                    )
                  ],
                ),
                PointsHelper().availableRewards(ref, user, points).isEmpty
                    ? const NoRewardsTile()
                    : isRewardsAvailable == false
                        ? const SizedBox(
                            height: 150,
                            child: OffersInUseTile(),
                          )
                        : Align(
                            alignment: Alignment.centerLeft,
                            child: SizedBox(
                              height: 200,
                              child: ListView.separated(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 15.0,
                                ),
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                itemCount: PointsHelper()
                                    .availableRewards(ref, user, points)
                                    .length,
                                separatorBuilder: (context, index) =>
                                    Spacing.horizontal(15),
                                itemBuilder: (context, index) =>
                                    AvailableRewardCard(index: index),
                              ),
                            ),
                          ),
              ],
            ),
          );
  }
}
