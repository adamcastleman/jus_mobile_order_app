import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/error.dart';
import 'package:jus_mobile_order_app/Helpers/loading.dart';
import 'package:jus_mobile_order_app/Models/wallet_activities_model.dart';
import 'package:jus_mobile_order_app/Providers/ProviderWidgets/user_provider_widget.dart';
import 'package:jus_mobile_order_app/Providers/stream_providers.dart';

class WalletActivitiesProviderWidget extends ConsumerWidget {
  final Widget Function(List<WalletActivitiesModel> activities) builder;
  final dynamic loading;
  final dynamic error;
  const WalletActivitiesProviderWidget(
      {required this.builder, this.loading, this.error, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return UserProviderWidget(builder: (user) {
      final walletActivities =
          ref.watch(walletActivitiesProvider(user.uid ?? ''));
      return walletActivities.when(
        error: (e, _) =>
            error ??
            ShowError(
              error: e.toString(),
            ),
        loading: () => loading ?? const Loading(),
        data: (activities) => builder(activities),
      );
    });
  }
}
