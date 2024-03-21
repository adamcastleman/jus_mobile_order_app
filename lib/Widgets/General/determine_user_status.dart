import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/enums.dart';
import 'package:jus_mobile_order_app/Providers/points_providers.dart';
import 'package:jus_mobile_order_app/Providers/stream_providers.dart';

class DetermineUserStatus extends ConsumerWidget {
  const DetermineUserStatus({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider).value!;
    final points = ref.watch(pointsInformationProvider);
    if (user.uid == null ||
        user.subscriptionStatus != SubscriptionStatus.active) {
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
  }
}
