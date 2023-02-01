import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Views/register_page.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/elevated_button_small.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/outlined_button_small.dart';
import 'package:jus_mobile_order_app/Widgets/Helpers/modal_bottom_sheets.dart';
import 'package:jus_mobile_order_app/Widgets/Helpers/spacing_widgets.dart';

class LoyaltyCardGuest extends ConsumerWidget {
  const LoyaltyCardGuest({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return UnconstrainedBox(
      child: SizedBox(
        height: 280,
        width: MediaQuery.of(context).size.width * 0.9,
        child: Card(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Join Rewards.',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                Text(
                  'Get Free Stuff.',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                Spacing().vertical(25),
                Text(
                  'Collect points',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                Text(
                  'and redeem for free items.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                Spacing().vertical(25),
                SmallElevatedButton(
                  buttonText: 'Join Now',
                  onPressed: () {
                    ModalBottomSheet().fullScreen(
                      context: context,
                      builder: (context) => const RegisterPage(),
                    );
                  },
                ),
                SmallOutlineButton(
                  buttonText: 'How Rewards Work',
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
