import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/error.dart';
import 'package:jus_mobile_order_app/Helpers/loading.dart';
import 'package:jus_mobile_order_app/Helpers/spacing_widgets.dart';
import 'package:jus_mobile_order_app/Providers/stream_providers.dart';
import 'package:jus_mobile_order_app/Providers/theme_providers.dart';
import 'package:jus_mobile_order_app/Widgets/Cards/favorite_card_empty.dart';
import 'package:jus_mobile_order_app/Widgets/Cards/favorites_card.dart';

import '../Widgets/Buttons/close_button.dart';

class FavoritesSheet extends ConsumerWidget {
  const FavoritesSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favorites = ref.watch(favoritesProvider);
    final backgroundColor = ref.watch(backgroundColorProvider);
    return favorites.when(
      error: (e, _) => ShowError(error: e.toString()),
      loading: () => const Loading(),
      data: (favorite) => Container(
        height: double.infinity,
        color: backgroundColor,
        padding: const EdgeInsets.only(top: 60.0, left: 12.0, right: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Align(
              alignment: Alignment.topRight,
              child: JusCloseButton(),
            ),
            Text(
              'Favorites',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            Spacing().vertical(30),
            favorite.isEmpty
                ? const Center(
                    child: SizedBox(
                      height: 250,
                      child: EmptyFavoriteCard(
                        isFavoriteSheet: true,
                      ),
                    ),
                  )
                : Expanded(
                    child: GridView.builder(
                      shrinkWrap: true,
                      primary: false,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 10,
                              crossAxisSpacing: 10,
                              childAspectRatio: 1 / 1.3),
                      itemCount: favorite.isEmpty ? 0 : favorite.length,
                      itemBuilder: (context, index) => FavoritesCard(
                        index: index,
                      ),
                    ),
                  )
          ],
        ),
      ),
    );
  }
}
