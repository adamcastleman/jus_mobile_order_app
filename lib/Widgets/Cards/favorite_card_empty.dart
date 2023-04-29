import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/locations.dart';
import 'package:jus_mobile_order_app/Helpers/spacing_widgets.dart';
import 'package:jus_mobile_order_app/Providers/location_providers.dart';
import 'package:jus_mobile_order_app/Providers/navigation_providers.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/elevated_button_small.dart';

class EmptyFavoriteCard extends ConsumerWidget {
  final bool isFavoriteSheet;
  const EmptyFavoriteCard({required this.isFavoriteSheet, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.95,
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4), color: Colors.white),
        child: Padding(
          padding: const EdgeInsets.only(
              top: 22.0, bottom: 18.0, left: 12.0, right: 12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Icon(CupertinoIcons.heart),
              Column(
                children: [
                  const AutoSizeText(
                    'No favorites yet...',
                    style: TextStyle(fontSize: 20.0),
                    maxLines: 1,
                  ),
                  Spacing().vertical(5),
                  const AutoSizeText(
                    'Tap the heart on the product detail page to save your favorites here for fast reordering',
                    style: TextStyle(fontSize: 12),
                    maxLines: 2,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              SmallElevatedButton(
                  buttonText: 'Order now',
                  onPressed: () {
                    if (ref.read(selectedLocationProvider) == null) {
                      LocationHelper().chooseLocation(context, ref);
                    }
                    ref.read(bottomNavigationProvider.notifier).state = 2;
                    isFavoriteSheet ? Navigator.pop(context) : null;
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
