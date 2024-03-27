import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/error.dart';
import 'package:jus_mobile_order_app/Helpers/loading.dart';
import 'package:jus_mobile_order_app/Models/square_subscription_model.dart';
import 'package:jus_mobile_order_app/Providers/future_providers.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/close_button.dart';

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
            child: SizedBox(
              height: double.infinity,
              child: Stack(
                children: [
                  Center(
                    child: ShowError(
                      error:
                          'We are unable to show your subscription data at the moment. Please try again later',
                    ),
                  ),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: JusCloseButton(),
                  )
                ],
              ),
            ),
          ),
      loading: () => loading ?? const Loading(),
      data: (subscription) => builder(subscription),
    );
  }
}
