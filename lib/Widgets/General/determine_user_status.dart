import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Providers/ProviderWidgets/points_details_provider_widget.dart';
import 'package:jus_mobile_order_app/Providers/stream_providers.dart';

class DetermineUserStatus extends ConsumerWidget {
  const DetermineUserStatus({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider).value!;
    return PointsDetailsProviderWidget(
      builder: (points) {
        if (user.uid == null || !user.isActiveMember!) {
          return Text(
            points.pointsStatus,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          );
        } else {
          return Text(
            points.memberPointsStatus,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          );
        }
      },
    );
  }
}
