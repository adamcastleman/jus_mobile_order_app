import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/error.dart';
import 'package:jus_mobile_order_app/Helpers/loading.dart';
import 'package:jus_mobile_order_app/Providers/future_providers.dart';

class VersionDisplayWidget extends ConsumerWidget {
  const VersionDisplayWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appVersion = ref.watch(appVersionProvider);
    return appVersion.when(
      error: (e, _) => const ShowError(
        error: 'Failed to get version',
      ),
      loading: () => const Loading(),
      data: (version) => Text(
        'v.$version',
      ),
    );
  }
}
