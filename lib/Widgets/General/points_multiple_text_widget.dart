import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/enums.dart';
import 'package:jus_mobile_order_app/Models/points_details_model.dart';
import 'package:jus_mobile_order_app/Providers/payments_providers.dart';
import 'package:jus_mobile_order_app/Providers/stream_providers.dart';

class PointsMultipleText extends ConsumerWidget {
  final PointsDetailsModel points;
  final TextStyle textStyle;
  const PointsMultipleText(
      {required this.points, required this.textStyle, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider).value!;
    final selectedCard = ref.watch(selectedPaymentMethodProvider);
    final isActiveMember = user.uid != null &&
        user.subscriptionStatus == SubscriptionStatus.active;
    num pointValue;

    if (!isActiveMember && selectedCard.brand != 'wallet') {
      pointValue = points.pointsPerDollar;
    } else if (!isActiveMember && selectedCard.brand == 'wallet') {
      pointValue = points.walletPointsPerDollar;
    } else if (isActiveMember && selectedCard.brand != 'wallet') {
      pointValue = points.memberPointsPerDollar;
    } else if (isActiveMember && selectedCard.brand == 'wallet') {
      pointValue = points.walletPointsPerDollarMember;
    } else {
      return const SizedBox();
    }

    return Text(
      '$pointValue ${pointValue == 1 ? 'point' : 'points'}/\$1',
      style: textStyle,
    );
  }
}
