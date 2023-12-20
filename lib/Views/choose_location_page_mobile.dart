import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Providers/theme_providers.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/close_button.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/map_search_area_button.dart';
import 'package:jus_mobile_order_app/Widgets/Lists/locations_list_mobile.dart';
import 'package:jus_mobile_order_app/Widgets/Map/map_display.dart';

class ChooseLocationPageMobile extends ConsumerWidget {
  const ChooseLocationPageMobile({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                          bottom: MediaQuery.of(context).size.height * 0.08),
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
                left: 8.0, top: MediaQuery.of(context).size.height * 0.095),
            child: const Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: SearchAreaButton(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
