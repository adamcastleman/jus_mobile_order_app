import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Models/favorites_model.dart';
import 'package:jus_mobile_order_app/Providers/product_providers.dart';

class FavoritesServices {
  final String? uid;
  final WidgetRef? ref;

  FavoritesServices({required this.uid, this.ref});

  Stream<List<FavoritesModel>> get favorites {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
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
        productID: data['productID'],
        size: data['size'],
        allergies: data['allergies'] as List,
      );
    }).toList();
  }

  addToFavorites(
      List<dynamic> currentIngredients, List<dynamic> currentToppings) {
    final CollectionReference favoritesCollection = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('favorites');
    final docID = favoritesCollection.doc().id;
    return favoritesCollection.doc(docID).set({
      'productID': ref!.watch(selectedProductIDProvider),
      'uid': docID,
      'name': ref!.watch(favoriteItemNameProvider),
      'ingredients': currentIngredients,
      'toppings': currentToppings,
      'size': ref!.watch(itemSizeProvider),
      'allergies': ref!.watch(selectedAllergiesProvider),
    });
  }

  deleteFromFavorites({required String docID}) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('favorites')
        .doc(docID)
        .delete();
  }
}
