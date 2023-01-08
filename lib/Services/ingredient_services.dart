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

  Stream<List<IngredientModel>> get modifiableIngredients {
    return ingredientCollection
        .where('isModifiable', isEqualTo: true)
        .orderBy('categoryOrder')
        .orderBy('id')
        .snapshots()
        .map(getIngredientsFromDatabase);
  }

  Stream<List<IngredientModel>> get blendOnlyIngredients {
    return ingredientCollection
        .where('isModifiable', isEqualTo: true)
        .where('isStandardTopping', isEqualTo: false)
        .orderBy('categoryOrder')
        .orderBy('id')
        .snapshots()
        .map(getIngredientsFromDatabase);
  }

  Stream<List<IngredientModel>> get toppingsOnlyIngredients {
    return ingredientCollection
        .where('isTopping', isEqualTo: true)
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
        id: data['id'],
        price: data['price'],
        memberPrice: data['memberPrice'],
        isModifiable: data['isModifiable'],
        isStandardTopping: data['isStandardTopping'],
        isExtraCharge: data['isExtraCharge'],
        isBlended: data['isBlended'],
        isTopping: data['isTopping'],
        containsDairy: data['containsDairy'],
        containsGluten: data['containsGluten'],
      );
    }).toList();
  }
}
