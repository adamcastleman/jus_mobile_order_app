import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/error.dart';
import 'package:jus_mobile_order_app/Helpers/loading.dart';
import 'package:jus_mobile_order_app/Providers/stream_providers.dart';

class DisplayImagesProviderWidget extends ConsumerWidget {
  final Widget Function(dynamic image) builder;
  final dynamic loading;
  final dynamic error;
  const DisplayImagesProviderWidget(
      {required this.builder, this.loading, this.error, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final image = ref.watch(displayImagesProvider);
    return image.when(
      error: (e, _) =>
          error ??
          ShowError(
            error: e.toString(),
          ),
      loading: () => loading ?? const Loading(),
      data: (image) => builder(image),
    );
  }
}
