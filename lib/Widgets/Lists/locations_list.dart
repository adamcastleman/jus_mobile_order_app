import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/spacing_widgets.dart';
import 'package:jus_mobile_order_app/Providers/controller_providers.dart';
import 'package:jus_mobile_order_app/Providers/location_providers.dart';
import 'package:jus_mobile_order_app/Widgets/Tiles/location_list_tile.dart';

import '../Tiles/empty_location_tile.dart';

class LocationListView extends ConsumerWidget {
  const LocationListView({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final visibleLocations = ref.watch(locationsWithinMapBoundsProvider);
    final scrollController = ref.watch(locationListControllerProvider);

    return ListView.separated(
      primary: false,
      padding: const EdgeInsets.only(top: 10.0, left: 12.0, right: 12.0),
      controller: scrollController,
      scrollDirection: Axis.horizontal,
      itemCount: visibleLocations.isEmpty ? 1 : visibleLocations.length,
      separatorBuilder: (context, index) => Spacing().horizontal(15),
      itemBuilder: (context, index) {
        if (visibleLocations.isEmpty) {
          return const EmptyLocationTile();
        } else {
          return LocationListTile(
            scrollController: scrollController,
            index: index,
          );
        }
      },
    );
  }
}
