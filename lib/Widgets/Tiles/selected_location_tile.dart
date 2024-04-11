import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/loading.dart';
import 'package:jus_mobile_order_app/Helpers/navigation.dart';
import 'package:jus_mobile_order_app/Helpers/utilities.dart';
import 'package:jus_mobile_order_app/Models/location_model.dart';
import 'package:jus_mobile_order_app/Providers/loading_providers.dart';
import 'package:jus_mobile_order_app/Providers/location_providers.dart';
import 'package:jus_mobile_order_app/Providers/theme_providers.dart';

import '../../Providers/order_providers.dart';

class SelectedLocationTile extends ConsumerWidget {
  final Color? tileColor;
  final Color? textColor;
  final Color? loadingColor;
  final bool? isEndDrawerOpen;
  const SelectedLocationTile(
      {this.tileColor,
      this.textColor,
      this.loadingColor,
      this.isEndDrawerOpen = false,
      super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final backgroundColor = ref.watch(backgroundColorProvider);
    final locations = ref.watch(allLocationsProvider);
    final selectedLocation = ref.watch(selectedLocationProvider);
    final isCheckoutPage = ref.watch(isCheckOutPageProvider);
    final isLocationLoading = ref.watch(locationLoadingProvider);

    if (selectedLocation.uid.isEmpty) {
      return _locationTileWidget(context, ref, selectedLocation,
          tileColor ?? backgroundColor, isCheckoutPage, isLocationLoading);
    }
    LocationModel location = locations.firstWhere(
        (location) => location.locationId == selectedLocation.locationId);
    return _locationTileWidget(context, ref, location,
        tileColor ?? backgroundColor, isCheckoutPage, isLocationLoading);
  }

  _locationTileWidget(
      BuildContext context,
      WidgetRef ref,
      LocationModel? selectedLocation,
      Color tileColor,
      bool isCheckoutPage,
      bool isLocationLoading) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      color: tileColor,
      height: ResponsiveLayout.isWeb(context) ? 85 : null,
      width: ResponsiveLayout.isMobileBrowser(context)
          ? MediaQuery.of(context).size.width
          : double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 500,
            ),
            child: ListTile(
              dense: true,
              tileColor: tileColor,
              leading: Icon(
                FontAwesomeIcons.locationDot,
                color: textColor ?? Colors.black,
                size: 28,
              ),
              title: Text(
                'Picking up from:',
                style: TextStyle(
                  fontSize: ResponsiveLayout.isMobilePhone(context) ? 13 : 14,
                  color: textColor ?? Colors.black,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _locationName(context, selectedLocation),
                ],
              ),
              trailing:
                  _determineTrailingIcon(isCheckoutPage, isLocationLoading),
              onTap: () {
                if (isCheckoutPage) {
                  return;
                } else {
                  HapticFeedback.lightImpact();
                  NavigationHelpers().navigateToLocationPage(context, ref);
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _locationName(BuildContext context, dynamic selectedLocation) {
    if (selectedLocation.uid.isEmpty) {
      return Text(
        'Choose Location',
        style: TextStyle(
          fontSize: ResponsiveLayout.isMobilePhone(context) ? 15 : 18,
          color: textColor ?? Colors.black,
          fontWeight: FontWeight.bold,
        ),
      );
    } else {
      return Text(
        '${selectedLocation.name}',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: textColor ?? Colors.black,
        ),
      );
    }
  }

  Widget _determineTrailingIcon(bool isCheckoutPage, bool isLocationLoading) {
    if (isCheckoutPage) {
      return const SizedBox();
    } else if (isLocationLoading) {
      // Check the state of the end drawer
      if (isEndDrawerOpen == true) {
        // End drawer is open, show loading on CheckoutPage
        return Container(
          height: 20,
          width: 20,
          alignment: Alignment.centerRight,
          child: Loading(
            color: loadingColor,
          ),
        );
      } else {
        // End drawer is closed, show loading on MenuPage
        return Icon(
          CupertinoIcons.chevron_up_circle_fill,
          size: 20,
          color: textColor ?? Colors.black,
        );
      }
    } else {
      return Icon(
        CupertinoIcons.chevron_up_circle_fill,
        size: 20,
        color: textColor ?? Colors.black,
      );
    }
  }
}
