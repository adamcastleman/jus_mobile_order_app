import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/error.dart';
import 'package:jus_mobile_order_app/Helpers/loading.dart';
import 'package:jus_mobile_order_app/Models/payments_model.dart';
import 'package:jus_mobile_order_app/Providers/stream_providers.dart';

class CreditCardProviderWidget extends ConsumerWidget {
  final Widget Function(List<PaymentsModel> cards) builder;
  final dynamic loading;
  final dynamic error;
  const CreditCardProviderWidget(
      {required this.builder, this.loading, this.error, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final paymentMethod = ref.watch(creditCardPaymentMethodsProvider);
    return paymentMethod.when(
      error: (e, _) =>
          error ??
          ShowError(
            error: e.toString(),
          ),
      loading: () => loading ?? const Loading(),
      data: (cards) {
        return builder(cards);
      },
    );
  }
}
