import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/error.dart';
import 'package:jus_mobile_order_app/Helpers/loading.dart';
import 'package:jus_mobile_order_app/Models/square_subscription_model.dart';
import 'package:jus_mobile_order_app/Providers/future_providers.dart';

class SquareSubscriptionProviderWidget extends ConsumerWidget {
  final String subscriptionId;
  final Widget Function(SquareSubscriptionModel subscription) builder;
  final dynamic loading;
  final dynamic error;
  const SquareSubscriptionProviderWidget(
      {required this.subscriptionId,
      required this.builder,
      this.loading,
      this.error,
      super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subscriptionData =
        ref.watch(getSubscriptionFromApiProvider(subscriptionId));
    return subscriptionData.when(
      error: (e, _) =>
          error ??
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 40.0),
            child: ShowError(
              error:
                  'We are unable to show your subscription data at the moment. Please try again later',
            ),
          ),
      loading: () => loading ?? const Loading(),
      data: (subscription) => builder(subscription),
    );
  }
}
