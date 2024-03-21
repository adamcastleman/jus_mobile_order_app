import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/spacing_widgets.dart';
import 'package:jus_mobile_order_app/Models/points_details_model.dart';
import 'package:jus_mobile_order_app/Providers/points_providers.dart';
import 'package:jus_mobile_order_app/constants.dart';
import 'package:jus_mobile_order_app/theme_data.dart';

class RewardsCard extends ConsumerWidget {
  final PointsDetailsModel points;
  final List<String> images;

  const RewardsCard({
    required this.points,
    required this.images,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = ref.watch(rewardAmountIndexProvider);

    return AspectRatio(
      aspectRatio: AppConstants.aspectRatioRewardsWeb,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: Column(
          children: [
            _buildPointsRow(context, ref, selectedIndex),
            Spacing.vertical(15),
            Expanded(
              child: _buildRewardInformationCard(selectedIndex),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPointsRow(
      BuildContext context, WidgetRef ref, int selectedIndex) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(
        points.rewardsAmounts.length,
        (index) => _buildPointItem(ref, index, selectedIndex),
      ),
    );
  }

  Widget _buildPointItem(WidgetRef ref, int index, int selectedIndex) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          onTap: () =>
              ref.read(rewardAmountIndexProvider.notifier).state = index,
          child: Text(
            '${points.rewardsAmounts[index]['amount']}',
            style: const TextStyle(fontSize: 18),
          ),
        ),
        const SizedBox(height: 4),
        if (index == selectedIndex)
          Container(
            width: 50,
            height: 1,
            color: Colors.black,
          ),
      ],
    );
  }

  Widget _buildRewardInformationCard(int index) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        color: Colors.white,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildImage(index),
          Flexible(
            child: _buildDescription(index,
                '${points.rewardsAmounts[index]['description']} - ${points.rewardsAmounts[index]['amount']} points'),
          ),
        ],
      ),
    );
  }

  Widget _buildImage(int index) {
    return AspectRatio(
      aspectRatio: 1.3,
      child: Container(
        constraints: const BoxConstraints(maxHeight: 400),
        child: CachedNetworkImage(
          imageUrl: images[index],
        ),
      ),
    );
  }

  Widget _buildDescription(int index, String text) {
    return DescriptionText(
      fontSize: 20,
      text: text,
      maxLines: 1,
    );
  }
}
