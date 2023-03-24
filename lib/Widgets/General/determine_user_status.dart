import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Providers/ProviderWidgets/points_details_provider_widget.dart';
import 'package:jus_mobile_order_app/Providers/ProviderWidgets/user_provider_widget.dart';

class DetermineUserStatus extends ConsumerWidget {
  const DetermineUserStatus({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return UserProviderWidget(
      builder: (user) => PointsDetailsProviderWidget(
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
      ),
    );
  }
}
