import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/error.dart';
import 'package:jus_mobile_order_app/Helpers/loading.dart';
import 'package:jus_mobile_order_app/Models/membership_stats_model.dart';
import 'package:jus_mobile_order_app/Providers/stream_providers.dart';

class MemberStatsProviderWidget extends ConsumerWidget {
  final Widget Function(MembershipStatsModel stats) builder;
  final dynamic loading;
  final dynamic error;
  const MemberStatsProviderWidget(
      {required this.builder, this.loading, this.error, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserProvider);
    return currentUser.when(
        error: (e, _) =>
            error ??
            ShowError(
              error: e.toString(),
            ),
        loading: () => loading ?? const Loading(),
        data: (user) {
          final memberStats = ref.watch(memberStatsProvider(user.uid ?? ''));
          return memberStats.when(
            error: (e, _) =>
                error ??
                ShowError(
                  error: e.toString(),
                ),
            loading: () => loading ?? const Loading(),
            data: (stats) => builder(stats),
          );
        });
  }
}
