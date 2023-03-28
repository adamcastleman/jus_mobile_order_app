import 'package:flutter/material.dart';
import 'package:jus_mobile_order_app/Helpers/modal_bottom_sheets.dart';
import 'package:jus_mobile_order_app/Helpers/spacing_widgets.dart';
import 'package:jus_mobile_order_app/Views/register_page.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/elevated_button_small.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/info_button.dart';

import '../../Views/points_detail_page.dart';

class RewardsGuestCheckout extends StatelessWidget {
  const RewardsGuestCheckout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 22.0),
      child: Center(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Earn points. Get free stuff.',
                  style: TextStyle(fontSize: 18),
                ),
                Spacing().horizontal(5),
                InfoButton(
                  onTap: () {
                    ModalBottomSheet().fullScreen(
                      context: context,
                      builder: (context) =>
                          const PointsDetailPage(closeButton: true),
                    );
                  },
                  size: 22,
                ),
              ],
            ),
            Spacing().vertical(20),
            SmallElevatedButton(
              buttonText: 'Join Rewards',
              onPressed: () {
                ModalBottomSheet().fullScreen(
                  context: context,
                  builder: (context) => const RegisterPage(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
