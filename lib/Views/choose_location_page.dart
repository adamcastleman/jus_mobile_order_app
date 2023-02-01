import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Providers/location_providers.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/close_button.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/order_here_button.dart';
import 'package:jus_mobile_order_app/Widgets/General/google_map.dart';
import 'package:jus_mobile_order_app/Widgets/Lists/locations_list.dart';

class ChooseLocationPage extends ConsumerWidget {
  const ChooseLocationPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var selectedLocation = ref.watch(selectedLocationProvider);
    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: Colors.grey[100],
              height: MediaQuery.of(context).size.height * 0.1,
              child: Align(
                  alignment: Alignment.bottomLeft,
                  child: JusCloseButton(
                    onPressed: () {
                      ref.invalidate(selectedLocationProvider);
                      Navigator.pop(context);
                    },
                  )),
            ),
            const Expanded(
              child: DisplayGoogleMap(),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.33,
              child: const LocationListView(),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 28.0),
          child: Align(
            alignment: Alignment.bottomRight,
            child: selectedLocation == null
                ? const SizedBox()
                : const OrderHereButton(),
          ),
        ),
      ],
    );
  }
}
