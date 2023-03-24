import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/error.dart';
import 'package:jus_mobile_order_app/Helpers/loading.dart';
import 'package:jus_mobile_order_app/Models/ingredient_model.dart';
import 'package:jus_mobile_order_app/Providers/stream_providers.dart';

class ModifiableIngredientsProviderWidget extends ConsumerWidget {
  final Widget Function(List<IngredientModel> ingredients) builder;
  final dynamic loading;
  final dynamic error;
  const ModifiableIngredientsProviderWidget(
      {required this.builder, this.loading, this.error, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ingredients = ref.watch(modifiableIngredientsProvider);
    return ingredients.when(
      error: (e, _) =>
          error ??
          ShowError(
            error: e.toString(),
          ),
      loading: () => loading ?? const Loading(),
      data: (ingredients) => builder(ingredients),
    );
  }
}
