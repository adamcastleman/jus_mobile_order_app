import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/modal_bottom_sheets.dart';
import 'package:jus_mobile_order_app/Helpers/spacing_widgets.dart';
import 'package:jus_mobile_order_app/Providers/ProviderWidgets/points_details_provider_widget.dart';
import 'package:jus_mobile_order_app/Providers/ProviderWidgets/user_provider_widget.dart';
import 'package:jus_mobile_order_app/Providers/payments_providers.dart';
import 'package:jus_mobile_order_app/Views/points_detail_page.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/info_button.dart';

class PointsMultipleText extends ConsumerWidget {
  const PointsMultipleText({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedCard = ref.watch(selectedPaymentMethodProvider);
    num pointValue;
    return UserProviderWidget(
      builder: (user) => PointsDetailsProviderWidget(builder: (points) {
        if (!user.isActiveMember! && selectedCard['brand'] != 'giftCard') {
          pointValue = points.pointsPerDollar;
        } else if (!user.isActiveMember! &&
            selectedCard['brand'] == 'giftCard') {
          pointValue = points.jusCardPointsPerDollar;
        } else if (user.isActiveMember! &&
            selectedCard['brand'] != 'giftCard') {
          pointValue = points.memberPointsPerDollar;
        } else if (user.isActiveMember! &&
            selectedCard['brand'] == 'giftCard') {
          pointValue = points.jusCardPointsPerDollarMember;
        } else {
          return const SizedBox();
        }

        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Earn $pointValue ${pointValue == 1 ? 'point' : 'points'}/\$1',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Spacing().horizontal(5),
            InfoButton(
              size: 20,
              onTap: () {
                ModalBottomSheet().fullScreen(
                    context: context,
                    builder: (context) =>
                        const PointsDetailPage(closeButton: true));
              },
            )
          ],
        );
      }),
    );
  }
}
