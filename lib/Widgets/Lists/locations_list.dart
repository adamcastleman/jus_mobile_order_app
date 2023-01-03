import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Providers/location_providers.dart';
import 'package:jus_mobile_order_app/Widgets/Tiles/location_list_tile.dart';

import '../Tiles/empty_location_tile.dart';

class LocationListView extends ConsumerWidget {
  const LocationListView({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final visibleLocations = ref.watch(locationsWithinMapBoundsProvider);

    return ListView.builder(
      primary: false,
      padding: const EdgeInsets.only(top: 10),
      itemCount: visibleLocations.isEmpty ? 1 : visibleLocations.length,
      itemBuilder: (context, index) {
        if (visibleLocations.isEmpty) {
          return const EmptyLocationTile();
        } else {
          return LocationListTile(
            index: index,
          );
        }
      },
    );
  }
}
