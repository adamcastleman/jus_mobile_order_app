import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/loading.dart';
import 'package:jus_mobile_order_app/Models/payments_model.dart';
import 'package:jus_mobile_order_app/Providers/stream_providers.dart';
import 'package:jus_mobile_order_app/Widgets/Icons/error_icon.dart';

class WalletProviderWidget extends ConsumerWidget {
  final Widget Function(List<PaymentsModel> cards) builder;
  final dynamic loading;
  final dynamic error;
  const WalletProviderWidget(
      {required this.builder, this.loading, this.error, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final paymentMethod = ref.watch(walletPaymentMethodsProvider);
    return paymentMethod.when(
      error: (e, _) => error ?? const ErrorIcon(),
      loading: () => loading ?? const Loading(),
      data: (cards) {
        return builder(cards);
      },
    );
  }
}
