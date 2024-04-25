import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/error.dart';
import 'package:jus_mobile_order_app/Helpers/loading.dart';
import 'package:jus_mobile_order_app/Models/points_activity_model.dart';
import 'package:jus_mobile_order_app/Providers/stream_providers.dart';

class PointsActivityProviderWidget extends ConsumerWidget {
  final Widget Function(List<PointsActivityModel> points) builder;
  final dynamic loading;
  final dynamic error;
  const PointsActivityProviderWidget(
      {required this.builder, this.loading, this.error, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider).value!;
    final pointsActivities = ref.watch(pointsActivityProvider(user.uid ?? ''));
    return pointsActivities.when(
      error: (e, _) =>
          error ??
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 40.0),
            child: ShowError(
              error: e.toString(),
              // 'We are unable to show your points activity at the moment. Please try again later',
            ),
          ),
      loading: () => loading ?? const Loading(),
      data: (points) => builder(points),
    );
  }
}
