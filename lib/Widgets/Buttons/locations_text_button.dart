import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/locations.dart';
import 'package:jus_mobile_order_app/Helpers/utilities.dart';
import 'package:jus_mobile_order_app/Providers/controller_providers.dart';
import 'package:jus_mobile_order_app/Providers/navigation_providers.dart';
import 'package:jus_mobile_order_app/Providers/theme_providers.dart';
import 'package:jus_mobile_order_app/constants.dart';

class LocationsTextButton extends ConsumerWidget {
  final double? fontSize;
  const LocationsTextButton({this.fontSize, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final buttonStyle =
        ref.watch(webNavigationButtonTextStyleProvider(fontSize ?? 18));
    return TextButton(
      child: Text('locations', style: buttonStyle),
      onPressed: () {
        LocationHelper().handleLocationPermissionsWeb(ref).then(
          (_) {
            ref.read(webNavigationProvider.notifier).state =
                AppConstants.locationPageWeb;
            ref
                .read(webNavigationPageControllerProvider)
                .jumpToPage(AppConstants.locationPageWeb);
            ResponsiveLayout.isMobile(context) ? Navigator.pop(context) : null;
          },
        );
      },
    );
  }
}
