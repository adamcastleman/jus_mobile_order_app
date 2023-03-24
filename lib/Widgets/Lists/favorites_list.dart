import 'package:flutter/material.dart';
import 'package:jus_mobile_order_app/Helpers/spacing_widgets.dart';
import 'package:jus_mobile_order_app/Providers/ProviderWidgets/favorites_provider_widget.dart';
import 'package:jus_mobile_order_app/Widgets/Cards/favorite_card_empty.dart';
import 'package:jus_mobile_order_app/Widgets/Cards/favorites_card.dart';

class FavoritesList extends StatelessWidget {
  const FavoritesList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FavoritesProviderWidget(
      builder: (favorites) => SizedBox(
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
