import 'package:flutter/material.dart';
import 'package:jus_mobile_order_app/Helpers/spacing_widgets.dart';
import 'package:jus_mobile_order_app/Models/favorites_model.dart';
import 'package:jus_mobile_order_app/Widgets/Cards/favorites_card.dart';

class FavoritesList extends StatelessWidget {
  final List<FavoritesModel> favorites;
  const FavoritesList({required this.favorites, super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 550,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Favorites',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
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
                separatorBuilder: (context, index) => Spacing.horizontal(15),
                itemCount: favorites.length,
                itemBuilder: (context, index) => FavoritesCard(
                  favoriteItem: favorites[index],
                  imageHeight: 300,
                  imageWidth: 300,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
