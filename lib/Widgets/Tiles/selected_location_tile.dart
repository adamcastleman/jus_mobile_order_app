import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Models/location_model.dart';
import 'package:jus_mobile_order_app/Providers/location_providers.dart';
import 'package:jus_mobile_order_app/Providers/stream_providers.dart';
import 'package:jus_mobile_order_app/Views/choose_location_page.dart';
import 'package:jus_mobile_order_app/Widgets/Helpers/error.dart';
import 'package:jus_mobile_order_app/Widgets/Helpers/modal_bottom_sheets.dart';
import 'package:jus_mobile_order_app/Widgets/Helpers/permission_handler.dart';

class SelectedLocationTile extends ConsumerWidget {
  const SelectedLocationTile({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedLocation = ref.watch(selectedLocationID);
    final locations = ref.watch(locationsProvider);
    return ListTile(
      contentPadding: selectedLocation == 0
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
      subtitle: locations.when(
        loading: () => const CircularProgressIndicator(),
        error: (Object e, _) => ShowError(error: e.toString()),
        data: (data) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            locationName(selectedLocation, locations),
            locationAddress(selectedLocation, locations),
          ],
        ),
      ),
      trailing: const Icon(
        CupertinoIcons.chevron_down,
        size: 20,
      ),
      onTap: () async {
        await HandlePermissions(context, ref).locationPermission();
        ModalBottomSheet().fullScreen(
          context: context,
          builder: (BuildContext context) => const ChooseLocationPage(),
        );
      },
    );
  }

  locationName(
      int selectedLocation, AsyncValue<List<LocationModel>> locations) {
    if (selectedLocation == 0) {
      return const Text(
        'Choose Location',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      );
    } else {
      var name = locations.value!
          .where((element) => element.locationID == selectedLocation)
          .first
          .name;
      return Text(
        name,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      );
    }
  }

  locationAddress(
      int selectedLocation, AsyncValue<List<LocationModel>> locations) {
    if (selectedLocation == 0) {
      return const SizedBox(
        height: 0,
        width: 0,
      );
    } else {
      var streetNumber = locations.value!
          .where((element) => element.locationID == selectedLocation)
          .first
          .address['streetNumber'];
      var streetName = locations.value!
          .where((element) => element.locationID == selectedLocation)
          .first
          .address['streetName'];
      var city = locations.value!
          .where((element) => element.locationID == selectedLocation)
          .first
          .address['city'];
      return Text(
        '$streetNumber $streetName, $city',
        style: const TextStyle(fontSize: 14),
      );
    }
  }
}
