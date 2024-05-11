import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/loading.dart';
import 'package:jus_mobile_order_app/Models/favorites_model.dart';
import 'package:jus_mobile_order_app/Providers/stream_providers.dart';
import 'package:jus_mobile_order_app/Widgets/Icons/error_icon.dart';

class FavoritesProviderWidget extends ConsumerWidget {
  final Widget Function(List<FavoritesModel> favorites) builder;
  final dynamic loading;
  final dynamic error;
  const FavoritesProviderWidget(
      {required this.builder, this.loading, this.error, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favorites = ref.watch(favoritesProvider);
    return favorites.when(
      error: (e, _) {
        return error ?? const ErrorIcon();
      },
      loading: () => loading ?? const Loading(),
      data: (favorites) => builder(favorites),
    );
  }
}
