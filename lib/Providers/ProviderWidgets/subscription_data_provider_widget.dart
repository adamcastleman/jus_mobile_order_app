import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/error.dart';
import 'package:jus_mobile_order_app/Helpers/loading.dart';
import 'package:jus_mobile_order_app/Models/subscription_model.dart';
import 'package:jus_mobile_order_app/Models/user_model.dart';
import 'package:jus_mobile_order_app/Providers/stream_providers.dart';

class SubscriptionDataProviderWidget extends ConsumerWidget {
  final Widget Function(SubscriptionModel stats) builder;
  final dynamic loading;
  final dynamic error;
  const SubscriptionDataProviderWidget(
      {required this.builder, this.loading, this.error, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider).value ?? const UserModel();
    final subscriptionData =
        ref.watch(subscriptionDataProvider(user.uid ?? ''));
    return subscriptionData.when(
        error: (e, _) =>
            error ??
            const ShowError(
              error:
                  'We are unable to show your subscription data at the moment. Please try again later',
            ),
        loading: () => loading ?? const Loading(),
        data: (subscription) {
          return builder(subscription);
        });
  }
}
