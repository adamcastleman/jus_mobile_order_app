import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/loading.dart';
import 'package:jus_mobile_order_app/Models/points_details_model.dart';
import 'package:jus_mobile_order_app/Providers/stream_providers.dart';
import 'package:jus_mobile_order_app/Widgets/Icons/error_icon.dart';

class PointsDetailsProviderWidget extends ConsumerWidget {
  final Widget Function(PointsDetailsModel points) builder;
  final dynamic loading;
  final dynamic error;
  const PointsDetailsProviderWidget(
      {required this.builder, this.loading, this.error, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final points = ref.watch(pointsDetailsProvider);
    return points.when(
        error: (e, _) => error ?? const ErrorIcon(),
        loading: () => loading ?? const Loading(),
        data: (points) {
          final sortedRewardsAmounts =
              List<Map<String, dynamic>>.from(points.rewardsAmounts);
          sortedRewardsAmounts.sort(
            (a, b) => a['amount'].compareTo(b['amount']),
          );
          final sortedPoints =
              points.copyWith(rewardsAmounts: sortedRewardsAmounts);
          return builder(sortedPoints);
        });
  }
}
