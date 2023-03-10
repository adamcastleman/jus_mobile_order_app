import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/error.dart';
import 'package:jus_mobile_order_app/Helpers/loading.dart';
import 'package:jus_mobile_order_app/Helpers/spacing_widgets.dart';
import 'package:jus_mobile_order_app/Providers/stream_providers.dart';
import 'package:jus_mobile_order_app/Widgets/Cards/favorite_card_empty.dart';
import 'package:jus_mobile_order_app/Widgets/Cards/favorites_card.dart';

class FavoritesList extends ConsumerWidget {
  const FavoritesList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favorites = ref.watch(favoritesProvider);
    return favorites.when(
      error: (e, _) => ShowError(error: e.toString()),
      loading: () => const Loading(),
      data: (favorites) => SizedBox(
        height: 270,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Favorites',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.centerLeft,
                child: ListView.separated(
                  shrinkWrap: true,
                  primary: false,
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  scrollDirection: Axis.horizontal,
                  separatorBuilder: (context, index) =>
                      Spacing().horizontal(15),
                  itemCount: favorites.isEmpty ? 1 : favorites.length,
                  itemBuilder: (context, index) => favorites.isEmpty
                      ? const EmptyFavoriteCard(
                          isFavoriteSheet: false,
                        )
                      : FavoritesCard(index: index),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
