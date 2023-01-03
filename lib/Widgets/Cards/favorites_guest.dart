import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/elevated_button_small.dart';
import 'package:jus_mobile_order_app/Widgets/Helpers/spacing_widgets.dart';

class FavoritesCardGuest extends ConsumerWidget {
  const FavoritesCardGuest({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return UnconstrainedBox(
      child: SizedBox(
        height: 250,
        width: MediaQuery.of(context).size.width * 0.9,
        child: Card(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Your favorites are waiting.',
                  style: Theme.of(context).textTheme.headline5,
                ),
                Spacing().vertical(25),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 22.0),
                  child: Text(
                    'If you order the same things every time, create an account to save your favorites so it\'s faster and easier to order next time.',
                    style: Theme.of(context).textTheme.bodyText2,
                    textAlign: TextAlign.center,
                  ),
                ),
                Spacing().vertical(25),
                SmallElevatedButton(
                  buttonText: 'Create Account',
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
