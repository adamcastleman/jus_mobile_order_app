import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/modal_bottom_sheets.dart';
import 'package:jus_mobile_order_app/Helpers/spacing_widgets.dart';
import 'package:jus_mobile_order_app/Views/register_page.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/elevated_button_small.dart';

class FavoritesCardGuest extends ConsumerWidget {
  const FavoritesCardGuest({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      color: Colors.white,
      height: 250,
      width: MediaQuery.of(context).size.width * 0.95,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              'Your favorites are waiting.',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            Spacing().vertical(25),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22.0),
              child: Text(
                'If you order the same things every time, create an account to save your favorites so it\'s faster and easier to order next time.',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ),
            Spacing().vertical(25),
            SmallElevatedButton(
              buttonText: 'Create Account',
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
