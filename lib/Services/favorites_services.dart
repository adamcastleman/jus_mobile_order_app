import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Models/favorites_model.dart';
import 'package:jus_mobile_order_app/Providers/product_providers.dart';

class FavoritesServices {
  final WidgetRef? ref;
  final String? userId;
  final int? productId;
  final int? itemSize;

  FavoritesServices({this.ref, this.userId, this.productId, this.itemSize});

  Stream<List<FavoritesModel>> get favorites {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(userId!)
        .collection('favorites')
        .snapshots()
        .map(getFavoritesFromDatabase);
  }

  List<FavoritesModel> getFavoritesFromDatabase(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      final dynamic data = doc.data();

      return FavoritesModel(
        uid: data['uid'],
        name: data['name'],
        ingredients: data['ingredients'],
        toppings: data['toppings'],
        productId: data['productId'],
        size: data['size'],
        allergies: data['allergies'] as List,
      );
    }).toList();
  }

  addToFavorites({
    required BuildContext context,
    required List<dynamic> currentIngredients,
    required List<dynamic> currentToppings,
    required Function(String) onError,
  }) async {
    try {
      await FirebaseFunctions.instance.httpsCallable('addToFavorites').call({
        'productId': ref!.watch(selectedProductIdProvider),
        'name': ref!.watch(favoriteItemNameProvider),
        'ingredients': currentIngredients,
        'toppings': currentToppings,
        'size': ref!.watch(itemSizeProvider),
        'allergies': ref!.watch(selectedAllergiesProvider),
      });
    } catch (e) {
      onError(e.toString());
    }
  }

  removeFromFavorites(
      {required BuildContext context,
      required String docID,
      required Function(String) onError}) async {
    try {
      await FirebaseFunctions.instance
          .httpsCallable('removeFromFavorites')
          .call({'docID': docID});
    } catch (e) {
      onError(e.toString());
    }
  }
}
