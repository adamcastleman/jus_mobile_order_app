import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/locations.dart';
import 'package:jus_mobile_order_app/Providers/location_providers.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/outlined_button_medium.dart';

class SearchAreaButton extends HookConsumerWidget {
  const SearchAreaButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Align(
      alignment: Alignment.topLeft,
      child: MediumOutlineButton(
        onPressed: () {
          LocationHelper().getCurrentBounds(ref);
          ref.invalidate(selectedLocationProvider);
        },
        buttonText: 'Search this area',
      ),
    );
  }
}
