import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/loading.dart';
import 'package:jus_mobile_order_app/Models/top_banner_model.dart';
import 'package:jus_mobile_order_app/Providers/stream_providers.dart';
import 'package:jus_mobile_order_app/Widgets/Icons/error_icon.dart';

class TopBannerProviderWidget extends ConsumerWidget {
  final Widget Function(TopBannerModel topBanner) builder;
  final dynamic loading;
  final dynamic error;
  const TopBannerProviderWidget(
      {required this.builder, this.loading, this.error, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final topBannerData = ref.watch(topBannerProvider);

    return topBannerData.when(
      error: (e, _) =>
          error ??
          const ErrorIcon(
            iconSize: 24,
          ),
      loading: () => loading ?? const Loading(),
      data: (banner) => builder(banner),
    );
  }
}
