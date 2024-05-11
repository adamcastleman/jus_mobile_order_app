import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/loading.dart';
import 'package:jus_mobile_order_app/Models/app_store_ids_model.dart';
import 'package:jus_mobile_order_app/Providers/stream_providers.dart';
import 'package:jus_mobile_order_app/Widgets/Icons/error_icon.dart';

class AppStoreIdsProviderWidget extends ConsumerWidget {
  final Widget Function(AppStoreIdsModel ids) builder;
  final dynamic loading;
  final dynamic error;
  const AppStoreIdsProviderWidget(
      {required this.builder, this.loading, this.error, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ids = ref.watch(appStoreIdsProvider);
    return ids.when(
      error: (e, _) => error ?? const ErrorIcon(),
      loading: () => loading ?? const Loading(),
      data: (ids) => builder(ids),
    );
  }
}
