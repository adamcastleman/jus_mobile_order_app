import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/loading.dart';
import 'package:jus_mobile_order_app/Providers/stream_providers.dart';
import 'package:jus_mobile_order_app/Widgets/Icons/error_icon.dart';

class DeleteAccountProviderWidget extends ConsumerWidget {
  final Widget Function(dynamic image) builder;
  final dynamic loading;
  final dynamic error;
  const DeleteAccountProviderWidget(
      {required this.builder, this.loading, this.error, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final image = ref.watch(deleteAccountImageProvider);
    return image.when(
      error: (e, _) => error ?? const ErrorIcon(),
      loading: () => loading ?? const Loading(),
      data: (image) => builder(image),
    );
  }
}
