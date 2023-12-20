import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Providers/ProviderWidgets/points_details_provider_widget.dart';
import 'package:jus_mobile_order_app/Providers/payments_providers.dart';
import 'package:jus_mobile_order_app/Providers/stream_providers.dart';

class PointsMultipleText extends ConsumerWidget {
  final TextStyle textStyle;
  const PointsMultipleText({required this.textStyle, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider).value!;
    final selectedCard = ref.watch(selectedPaymentMethodProvider);
    num pointValue;
    return PointsDetailsProviderWidget(builder: (points) {
      if (!user.isActiveMember! && selectedCard['brand'] != 'wallet') {
        pointValue = points.pointsPerDollar;
      } else if (!user.isActiveMember! && selectedCard['brand'] == 'wallet') {
        pointValue = points.walletPointsPerDollar;
      } else if (user.isActiveMember! && selectedCard['brand'] != 'wallet') {
        pointValue = points.memberPointsPerDollar;
      } else if (user.isActiveMember! && selectedCard['brand'] == 'wallet') {
        pointValue = points.walletPointsPerDollarMember;
      } else {
        return const SizedBox();
      }

      return Text(
        'Earn $pointValue ${pointValue == 1 ? 'point' : 'points'}/\$1',
        style: textStyle,
      );
    });
  }
}
