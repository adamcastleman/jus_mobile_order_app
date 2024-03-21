import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/loading.dart';
import 'package:jus_mobile_order_app/Helpers/utilities.dart';
import 'package:jus_mobile_order_app/Providers/loading_providers.dart';
import 'package:jus_mobile_order_app/Providers/theme_providers.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/map_search_area_button.dart';
import 'package:jus_mobile_order_app/Widgets/Lists/location_list_web.dart';
import 'package:jus_mobile_order_app/Widgets/Map/map_display.dart';

class LocationPageWeb extends ConsumerWidget {
  const LocationPageWeb({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final backgroundColor = ref.watch(backgroundColorProvider);
    final isLoading = ref.watch(loadingProvider);

    return ResponsiveLayout(
      mobileBrowser: _mobileMapLayout(backgroundColor, isLoading),
      tablet: _mobileMapLayout(backgroundColor, isLoading),
      web: _webMapLayout(context, backgroundColor, isLoading),
    );
  }

  Widget _mobileMapLayout(Color backgroundColor, bool isLoading) {
    return Container(
      color: backgroundColor,
      child: Column(
        children: [
          Expanded(
            child: isLoading
                ? const Loading()
                : Stack(
                    children: [
                      const DisplayGoogleMap(),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30.0),
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: Container(
                            padding: const EdgeInsets.only(top: 20.0),
                            width: 150,
                            child: const SearchAreaButton(),
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
          const SizedBox(
            height: 300.0,
            child: LocationListWeb(),
          ),
        ],
      ),
    );
  }

  Widget _webMapLayout(
      BuildContext context, Color backgroundColor, bool isLoading) {
    return Container(
      color: backgroundColor,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.only(top: 20.0),
            width: MediaQuery.of(context).size.width * 0.28,
            child: const LocationListWeb(),
          ),
          Expanded(
            child: Stack(
              children: [
                const DisplayGoogleMap(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      padding: const EdgeInsets.only(top: 20.0),
                      width: 150,
                      child: const SearchAreaButton(),
                    ),
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
