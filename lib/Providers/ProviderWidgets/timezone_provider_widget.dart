import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/loading.dart';
import 'package:jus_mobile_order_app/Providers/future_providers.dart';
import 'package:jus_mobile_order_app/Widgets/Icons/error_icon.dart';

class TimezoneProviderWidget extends ConsumerWidget {
  final Widget Function(String timezone) builder;
  final dynamic loading;
  final dynamic error;
  const TimezoneProviderWidget(
      {required this.builder, this.loading, this.error, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final deviceTime = ref.watch(deviceTimezoneProvider);

    return deviceTime.when(
      error: (e, _) => error ?? const ErrorIcon(),
      loading: () => loading ?? const Loading(),
      data: (timezone) => builder(timezone),
    );
  }
}
