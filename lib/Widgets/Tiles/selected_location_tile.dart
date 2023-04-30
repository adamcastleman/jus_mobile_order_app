import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/locations.dart';
import 'package:jus_mobile_order_app/Models/location_model.dart';
import 'package:jus_mobile_order_app/Providers/ProviderWidgets/location_provider_widget.dart';
import 'package:jus_mobile_order_app/Providers/location_providers.dart';

import '../../Providers/order_providers.dart';

class SelectedLocationTile extends ConsumerWidget {
  const SelectedLocationTile({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedLocation = ref.watch(selectedLocationProvider);
    final isCheckoutPage = ref.watch(checkOutPageProvider);
    return LocationsProviderWidget(
      builder: (locations) => ListTile(
        contentPadding: selectedLocation == null
            ? const EdgeInsets.symmetric(horizontal: 15.0)
            : const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15.0),
        leading: const Icon(
          FontAwesomeIcons.locationDot,
          color: Colors.black,
          size: 28,
        ),
        title: const Padding(
          padding: EdgeInsets.only(bottom: 2.0),
          child: Text(
            'Picking up from:',
            style: TextStyle(fontSize: 14),
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            locationName(selectedLocation, locations),
            locationAddress(selectedLocation, locations),
          ],
        ),
        trailing: isCheckoutPage
            ? const SizedBox()
            : const Icon(
                CupertinoIcons.chevron_down,
                size: 20,
              ),
        onTap: () {
          if (isCheckoutPage) {
            return;
          } else {
            HapticFeedback.lightImpact();
            LocationHelper().chooseLocation(context, ref);
          }
        },
      ),
    );
  }

  locationName(dynamic selectedLocation, List<LocationModel> locations) {
    if (selectedLocation == null) {
      return const Text(
        'Choose Location',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      );
    } else {
      return Text(
        '${selectedLocation.name}',
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      );
    }
  }

  locationAddress(dynamic selectedLocation, List<LocationModel> locations) {
    if (selectedLocation == null) {
      return const SizedBox(
        height: 0,
        width: 0,
      );
    } else {
      return Text(
        '${selectedLocation.address['streetNumber']} ${selectedLocation.address['streetName']}, ${selectedLocation.address['city']}',
        style: const TextStyle(fontSize: 14),
      );
    }
  }
}
