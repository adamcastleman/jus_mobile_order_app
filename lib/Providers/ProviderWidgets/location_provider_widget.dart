import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/error.dart';
import 'package:jus_mobile_order_app/Helpers/loading.dart';
import 'package:jus_mobile_order_app/Models/location_model.dart';
import 'package:jus_mobile_order_app/Providers/stream_providers.dart';

class LocationsProviderWidget extends ConsumerWidget {
  final Widget Function(List<LocationModel> user) builder;
  final dynamic loading;
  final dynamic error;
  const LocationsProviderWidget(
      {required this.builder, this.loading, this.error, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locations = ref.watch(locationsProvider);
    return locations.when(
      error: (e, _) =>
          error ??
          ShowError(
            error: e.toString(),
          ),
      loading: () => loading ?? const Loading(),
      data: (locations) => builder(locations),
    );
  }
}
