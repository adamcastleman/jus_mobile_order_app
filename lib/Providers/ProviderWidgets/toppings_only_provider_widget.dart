import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/error.dart';
import 'package:jus_mobile_order_app/Helpers/loading.dart';
import 'package:jus_mobile_order_app/Models/ingredient_model.dart';
import 'package:jus_mobile_order_app/Providers/stream_providers.dart';

class ToppingsOnlyProviderWidget extends ConsumerWidget {
  final Widget Function(List<IngredientModel> toppings) builder;
  final dynamic loading;
  final dynamic error;
  const ToppingsOnlyProviderWidget(
      {required this.builder, this.loading, this.error, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final toppings = ref.watch(toppingsOnlyIngredientsProvider);
    return toppings.when(
      error: (e, _) =>
          error ??
          ShowError(
            error: e.toString(),
          ),
      loading: () => loading ?? const Loading(),
      data: (toppings) => builder(toppings),
    );
  }
}
