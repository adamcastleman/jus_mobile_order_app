import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/error.dart';
import 'package:jus_mobile_order_app/Helpers/loading.dart';
import 'package:jus_mobile_order_app/Models/payments_model.dart';
import 'package:jus_mobile_order_app/Providers/stream_providers.dart';

class DefaultPaymentMethodProviderWidget extends ConsumerWidget {
  final Widget Function(PaymentsModel card) builder;
  final dynamic loading;
  final dynamic error;
  const DefaultPaymentMethodProviderWidget(
      {required this.builder, this.loading, this.error, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final paymentMethod = ref.watch(defaultPaymentMethodProvider);
    return paymentMethod.when(
        error: (e, _) =>
            error ??
            ShowError(
              error: e.toString(),
            ),
        loading: () => loading ?? const Loading(),
        data: (card) {
          return builder(card);
        });
  }
}
