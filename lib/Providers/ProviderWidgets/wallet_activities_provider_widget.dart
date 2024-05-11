import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/loading.dart';
import 'package:jus_mobile_order_app/Models/wallet_activities_model.dart';
import 'package:jus_mobile_order_app/Providers/stream_providers.dart';
import 'package:jus_mobile_order_app/Widgets/Icons/error_icon.dart';

class WalletActivitiesProviderWidget extends ConsumerWidget {
  final Widget Function(List<WalletActivitiesModel> activities) builder;
  final dynamic loading;
  final dynamic error;
  const WalletActivitiesProviderWidget(
      {required this.builder, this.loading, this.error, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider).value!;
    final walletActivities =
        ref.watch(walletActivitiesProvider(user.uid ?? ''));
    return walletActivities.when(
      error: (e, _) => error ?? const ErrorIcon(),
      loading: () => loading ?? const Loading(),
      data: (activities) => builder(activities),
    );
  }
}
