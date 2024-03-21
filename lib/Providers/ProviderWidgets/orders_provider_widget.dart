import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/error.dart';
import 'package:jus_mobile_order_app/Helpers/loading.dart';
import 'package:jus_mobile_order_app/Models/order_model.dart';
import 'package:jus_mobile_order_app/Providers/stream_providers.dart';

class OrdersProviderWidget extends ConsumerWidget {
  final Widget Function(List<OrderModel> orders) builder;
  final dynamic loading;
  final dynamic error;
  const OrdersProviderWidget(
      {required this.builder, this.loading, this.error, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider).value!;
    final orders = ref.watch(ordersProvider(user.uid ?? ''));
    return orders.when(
      error: (e, _) =>
          error ??
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 40.0),
            child:
            ShowError(
              error:
              'We are unable to show your transaction history at the moment. Please try again later',
            ),
          ),
      loading: () => loading ?? const Loading(),
      data: (orders) => builder(orders),
    );
  }
}
