import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/error.dart';
import 'package:jus_mobile_order_app/Helpers/loading.dart';
import 'package:jus_mobile_order_app/Models/offers_model.dart';
import 'package:jus_mobile_order_app/Providers/stream_providers.dart';

class OffersProviderWidget extends ConsumerWidget {
  final Widget Function(List<OffersModel> offers) builder;
  final dynamic loading;
  final dynamic error;
  const OffersProviderWidget(
      {required this.builder, this.loading, this.error, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final offers = ref.watch(offersProvider);
    return offers.when(
      error: (e, _) =>
          error ??
          ShowError(
            error: e.toString(),
          ),
      loading: () => loading ?? const Loading(),
      data: (offers) => builder(offers),
    );
  }
}
