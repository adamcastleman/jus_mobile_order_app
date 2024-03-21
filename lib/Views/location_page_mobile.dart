import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Providers/theme_providers.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/close_button.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/map_search_area_button.dart';
import 'package:jus_mobile_order_app/Widgets/Lists/locations_list_mobile.dart';
import 'package:jus_mobile_order_app/Widgets/Map/map_display.dart';

class LocationPageMobile extends ConsumerWidget {
  const LocationPageMobile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final backgroundColor = ref.watch(backgroundColorProvider);
    final screenHeight = MediaQuery.of(context).size.height;
    final closeButtonPaddingTop = screenHeight * 0.07;

    return Container(
      color: backgroundColor,
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Stack(
                  children: [
                    const DisplayGoogleMap(),
                    Padding(
                      padding: EdgeInsets.only(bottom: screenHeight * 0.08),
                      child: const Align(
                        alignment: Alignment.bottomCenter,
                        child: SizedBox(
                          height: 150,
                          child: LocationListViewMobile(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(
                left: 8.0, right: 8.0, top: closeButtonPaddingTop),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 3.0),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: SearchAreaButton(),
                  ),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: JusCloseButton(
                    iconSize: 30,
                    onPressed: () {
                      HapticFeedback.lightImpact();
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
