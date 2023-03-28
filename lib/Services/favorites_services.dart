import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/modal_bottom_sheets.dart';
import 'package:jus_mobile_order_app/Models/favorites_model.dart';
import 'package:jus_mobile_order_app/Providers/product_providers.dart';
import 'package:jus_mobile_order_app/Widgets/Payments/invalid_payment_sheet.dart';

class FavoritesServices {
  final WidgetRef? ref;
  final String? userID;

  FavoritesServices({this.ref, this.userID});

  Stream<List<FavoritesModel>> get favorites {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(userID!)
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

  addToFavorites(BuildContext context, List<dynamic> currentIngredients,
      List<dynamic> currentToppings) async {
    try {
      await FirebaseFunctions.instance.httpsCallable('addToFavorites').call({
        'productID': ref!.watch(selectedProductIDProvider),
        'name': ref!.watch(favoriteItemNameProvider),
        'ingredients': currentIngredients,
        'toppings': currentToppings,
        'size': ref!.watch(itemSizeProvider),
        'allergies': ref!.watch(selectedAllergiesProvider),
      });
    } catch (e) {
      ModalBottomSheet().partScreen(
        context: context,
        builder: (context) => InvalidDatabaseEntrySheet(
          error: e.toString(),
        ),
      );
    }
  }

  deleteFromFavorites(
      {required BuildContext context, required String docID}) async {
    try {
      await FirebaseFunctions.instance
          .httpsCallable('removeFromFavorites')
          .call({'docID': docID});
    } catch (e) {
      ModalBottomSheet().partScreen(
        context: context,
        builder: (context) => InvalidDatabaseEntrySheet(
          error: e.toString(),
        ),
      );
    }
  }
}
