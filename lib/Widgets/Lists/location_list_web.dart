import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/spacing_widgets.dart';
import 'package:jus_mobile_order_app/Providers/location_providers.dart';
import 'package:jus_mobile_order_app/Widgets/Tiles/empty_location_tile.dart';
import 'package:jus_mobile_order_app/Widgets/Tiles/location_list_tile.dart';

class LocationListWeb extends ConsumerWidget {
  const LocationListWeb({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final visibleLocations = ref.watch(locationsWithinMapBoundsProvider);

    return ListView.separated(
      primary: false,
      itemCount: visibleLocations.isEmpty ? 1 : visibleLocations.length,
      separatorBuilder: (context, index) => Spacing.vertical(10.0),
      itemBuilder: (context, index) {
        if (visibleLocations.isEmpty) {
          return const EmptyLocationTile();
        } else {
          return LocationListTile(
            tileWidth: MediaQuery.of(context).size.width,
            index: index,
          );
        }
      },
    );
  }
}
