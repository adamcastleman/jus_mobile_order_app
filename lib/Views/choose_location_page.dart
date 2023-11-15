import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Providers/location_providers.dart';
import 'package:jus_mobile_order_app/Providers/theme_providers.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/close_button.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/order_here_button.dart';
import 'package:jus_mobile_order_app/Widgets/Lists/locations_list.dart';
import 'package:jus_mobile_order_app/Widgets/Map/map_display.dart';

class ChooseLocationPage extends ConsumerWidget {
  const ChooseLocationPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var selectedLocation = ref.watch(selectedLocationProvider);
    final backgroundColor = ref.watch(backgroundColorProvider);
    return Container(
      color: backgroundColor,
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                color: Colors.grey[100],
                height: MediaQuery.of(context).size.height * 0.1,
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: JusCloseButton(
                    onPressed: () {
                      HapticFeedback.lightImpact();
                      Navigator.pop(context);
                    },
                  ),
                ),
              ),
              Expanded(
                child: Stack(
                  children: [
                    const DisplayGoogleMap(),
                    Padding(
                      padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).size.height * 0.13),
                      child: const Align(
                        alignment: Alignment.bottomCenter,
                        child: SizedBox(
                          height: 120,
                          child: LocationListView(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 18.0, vertical: 28.0),
            child: Align(
              alignment: Alignment.bottomRight,
              child: selectedLocation == null
                  ? const SizedBox()
                  : const OrderHereButton(),
            ),
          ),
        ],
      ),
    );
  }
}
