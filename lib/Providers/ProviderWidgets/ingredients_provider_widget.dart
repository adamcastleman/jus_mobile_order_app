import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/loading.dart';
import 'package:jus_mobile_order_app/Models/ingredient_model.dart';
import 'package:jus_mobile_order_app/Providers/stream_providers.dart';
import 'package:jus_mobile_order_app/Widgets/Icons/error_icon.dart';

class IngredientsProviderWidget extends ConsumerWidget {
  final Widget Function(List<IngredientModel> ingredients) builder;
  final dynamic loading;
  final dynamic error;
  const IngredientsProviderWidget(
      {required this.builder, this.loading, this.error, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ingredients = ref.watch(ingredientsProvider);
    return ingredients.when(
      error: (e, _) => error ?? const ErrorIcon(),
      loading: () => loading ?? const Loading(),
      data: (ingredients) => builder(ingredients),
    );
  }
}
