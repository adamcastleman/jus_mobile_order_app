import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/loading.dart';
import 'package:jus_mobile_order_app/Providers/future_providers.dart';
import 'package:jus_mobile_order_app/Widgets/Icons/error_icon.dart';

class BreakingVersionProviderWidget extends ConsumerWidget {
  final Widget Function(bool isBreakingChange) builder;
  final dynamic loading;
  final dynamic error;
  const BreakingVersionProviderWidget(
      {required this.builder, this.loading, this.error, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final versionComparison = ref.watch(isBreakingChangeProvider);
    return versionComparison.when(
      error: (e, _) => error ?? const ErrorIcon(),
      loading: () => loading ?? const Loading(),
      data: (isBreakingChange) => builder(isBreakingChange),
    );
  }
}
