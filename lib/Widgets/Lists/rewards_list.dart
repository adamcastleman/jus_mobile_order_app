import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:jus_mobile_order_app/Helpers/error.dart';
import 'package:jus_mobile_order_app/Helpers/loading.dart';
import 'package:jus_mobile_order_app/Helpers/modal_bottom_sheets.dart';
import 'package:jus_mobile_order_app/Helpers/points.dart';
import 'package:jus_mobile_order_app/Helpers/spacing_widgets.dart';
import 'package:jus_mobile_order_app/Providers/points_providers.dart';
import 'package:jus_mobile_order_app/Providers/stream_providers.dart';
import 'package:jus_mobile_order_app/Views/points_detail_page.dart';
import 'package:jus_mobile_order_app/Widgets/Cards/available_rewards_card.dart';
import 'package:jus_mobile_order_app/Widgets/Tiles/no_rewards_tile.dart';
import 'package:jus_mobile_order_app/Widgets/Tiles/offer_in_use_tile.dart';
import 'package:jus_mobile_order_app/Widgets/Tiles/rewards_guest_checkout.dart';

class RewardsList extends ConsumerWidget {
  const RewardsList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pointsInUse = ref.watch(pointsInUseProvider);
    final currentUser = ref.watch(currentUserProvider);
    final isRewardsAvailable = ref.watch(isRewardsAvailableProvider);
    return currentUser.when(
      error: (e, _) => ShowError(error: e.toString()),
      loading: () => const Loading(),
      data: (user) => user.uid == null
          ? const RewardsGuestCheckout()
          : SizedBox(
              height: PointsHelper(ref: ref).availableRewards().isEmpty ||
                      isRewardsAvailable == false
                  ? 150
                  : 250,
              child: Stack(
                children: [
                  Row(
                    children: [
                      PointsHelper(ref: ref).availableRewards().isEmpty
                          ? Text('Available Points: ${user.totalPoints!}')
                          : Text(
                              'Points: ${NumberFormat('#,###').format(pointsInUse)} / ${NumberFormat('#,###').format(user.totalPoints!)}',
                              style: const TextStyle(fontSize: 16),
                            ),
                      Spacing().horizontal(5),
                      InkWell(
                        onTap: () {
                          ModalBottomSheet().fullScreen(
                            context: context,
                            builder: (context) =>
                                const PointsDetailPage(isScanPage: false),
                          );
                        },
                        child: const Icon(
                          CupertinoIcons.info,
                          size: 16,
                        ),
                      ),
                    ],
                  ),
                  PointsHelper(ref: ref).availableRewards().isEmpty
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
                                  itemCount: PointsHelper(ref: ref)
                                      .availableRewards()
                                      .length,
                                  separatorBuilder: (context, index) =>
                                      Spacing().horizontal(15),
                                  itemBuilder: (context, index) =>
                                      AvailableRewardCard(index: index),
                                ),
                              ),
                            ),
                ],
              ),
            ),
    );
  }
}
