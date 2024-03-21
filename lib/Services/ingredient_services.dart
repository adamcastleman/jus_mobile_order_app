import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jus_mobile_order_app/Models/ingredient_model.dart';

class IngredientServices {
  CollectionReference ingredientCollection =
      FirebaseFirestore.instance.collection('ingredients');

  Stream<List<IngredientModel>> get ingredients {
    return ingredientCollection
        .orderBy('categoryOrder')
        .orderBy('id')
        .snapshots()
        .map(getIngredientsFromDatabase);
  }

  List<IngredientModel> getIngredientsFromDatabase(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      final dynamic data = doc.data();
      return IngredientModel(
        uid: data['uid'],
        name: data['name'],
        image: data['image'],
        category: data['category'],
        categoryOrder: data['categoryOrder'],
        id: data['id'],
        price: data['price'],
        memberPrice: data['memberPrice'],
        allergens: data['allergens'],
        isModifiable: data['isModifiable'],
        isStandardTopping: data['isStandardTopping'],
        isExtraCharge: data['isExtraCharge'],
        isBlended: data['isBlended'],
        isTopping: data['isTopping'],
        includeInAllergiesList: data['includeInAllergiesList'],
      );
    }).toList();
  }
}
